# Check a post against the citation house style (HANDOFF.md, "Citations").
# Usage: ruby tools/check-citations.rb REV PATH [--against OLD_REV]
#   REV may be a git revision or file=/local/path (for tests).
#   --against OLD_REV: also require the visible text to be unchanged apart from removed link
#   markup and added cite markers (whitespace-normalised).
# Exit 0 = all checks pass; 1 = problems found (each printed as FAIL; WARN lines don't fail).
require "yaml"
require "date"

rev, path, flag, old_rev = ARGV
abort "usage: REV PATH [--against OLD_REV]" unless path

def show(rev, path)
  return File.read(rev.sub("file=", "")) if rev.start_with?("file=")
  out = IO.popen(["git", "show", "#{rev}:#{path}"], &:read)
  abort "cannot read #{rev}:#{path}" unless $?.success?
  out
end

LINK = /\[((?:[^\[\]]|\[[^\]]*\])*)\]\(([^)\s]+)\)/
CITE = /\{%-?\s*include\s+cite\.html\s+n=(\S+?)\s*-?%\}/

def split(src)
  m = src.match(/\A---\n(.*?)\n---\n(.*)\z/m) or abort "no front matter"
  [YAML.safe_load(m[1], [Date, Time]), m[2]]
end

# Body with fenced code blocks and inline code blanked out (same length), so they're never checked.
def prose(body)
  b = body.gsub(/^(```|~~~).*?^\1[^\n]*$/m) { |c| c.gsub(/[^\n]/, " ") }
  b.gsub(/`[^`\n]*`/) { |c| "C" * c.size } # letters, not spaces, so a sentence can start with code
end

def plain(body)
  t = body.gsub(CITE, "")
  t = t.gsub(LINK) { $1 } while t =~ LINK
  t.gsub(/[ \t]+/, " ").gsub(/ +([.,;:!?])/, '\1').gsub(/ *\n */, "\n").strip
end

fm, body = split(show(rev, path))
sources = (fm["sources"] || []).map { |s| s["url"] }
fails = []
warns = []
text = prose(body)

markers = []
text.to_enum(:scan, CITE).each { markers << [Regexp.last_match[1], Regexp.last_match.begin(0)] }
links = []
text.to_enum(:scan, LINK).each { links << [Regexp.last_match[2], Regexp.last_match.begin(0), Regexp.last_match[1]] }

line_of = ->(pos) { text[0...pos].count("\n") + 1 }

# 1. markers whose n doesn't exist
markers.each do |n, pos|
  unless n =~ /\A\d+\z/ && n.to_i.between?(1, sources.size)
    fails << "marker n=#{n} at line #{line_of.(pos)} doesn't match a source (there are #{sources.size})"
  end
end

# 2. each source: exactly one inline link; cited at least once (link or marker)
sources.each_with_index do |url, i|
  n = i + 1
  count = links.count { |u, _, _| u == url }
  fails << "source #{n} (#{url}) has #{count} inline links; needs exactly 1" if count != 1
  cited = count > 0 || markers.any? { |m, _| m.to_i == n }
  fails << "source #{n} (#{url}) is never cited" unless cited
end

# 3. inline links to URLs that aren't sources (excluding in-page anchors)
links.reject { |u, _, _| u.start_with?("#") || sources.include?(u) }.each do |u, pos, _|
  fails << "inline link at line #{line_of.(pos)} to #{u}, which isn't in sources:"
end

# 4. markers inside quotation marks (straight or curly), counted within the paragraph
markers.each do |n, pos|
  para_start = (text.rindex(/\n\s*\n/, pos) || 0)
  before = text[para_start...pos].gsub(LINK) { $1 }.gsub(CITE, "")
  straight = before.count('"')
  curly_open = before.count("“") - before.count("”")
  if straight.odd? || curly_open > 0
    fails << "marker n=#{n} at line #{line_of.(pos)} is inside a quotation: …#{text[[pos - 50, para_start].max...pos].gsub(/\s+/, ' ')}"
  end
end

# 5. at most one marker per source per sentence; markers in headings
sentences = []
text.split(/\n\s*\n/).each do |para|
  next if para.strip.start_with?("|") # tables: one cell per claim, sentence rule doesn't apply
  if para.strip.start_with?("#")
    warns << "marker in a heading: #{para.strip[0, 60]}" if para =~ CITE
    next
  end
  # Each line of a list is its own unit; within a line, split after . ! ? (optionally followed by a
  # closing quote/bracket and markers) before whitespace and a capital, digit, quote or markup.
  para.split(/\n(?=\s*(?:[-*+]|\d+\.)\s)/).each do |item|
    item.split(/(?:(?<=[.!?])|(?<=[.!?]["”’)]))(?:\{%[^%]*%\})*\s+(?=["“(\[*_A-Z0-9`]|\{%)/).each { |s| sentences << s }
  end
end
sentences.each do |s|
  ns = s.scan(CITE).flatten
  ns.group_by(&:itself).each do |n, v|
    fails << "#{v.size} markers for source #{n} in one sentence: #{s.gsub(/\s+/, ' ')[0, 90]}…" if v.size > 1
  end
end

# 6. optional: visible text unchanged against an older revision
if flag == "--against"
  _, obody = split(show(old_rev, path))
  a, b = plain(obody), plain(body)
  if a != b
    i = (0...[a.size, b.size].min).find { |k| a[k] != b[k] } || [a.size, b.size].min
    fails << "visible text differs from #{old_rev} at char #{i}:\n    old: …#{a[[i - 50, 0].max, 120].inspect}\n    new: …#{b[[i - 50, 0].max, 120].inspect}"
  end
end

# 7. audio: an unquoted m:ss duration is read by YAML as h:mm (12:34 -> 45240 s). Require quotes or seconds.
raw_fm = show(rev, path)[/\A---\n(.*?)\n---/m, 1].to_s
if raw_fm =~ /^\s*duration:\s*\d+:\d+(:\d+)?\s*(#.*)?$/
  fails << "audio duration must be quoted (\"12:34\") or given in seconds; unquoted YAML reads 12:34 as 12 h 34 min"
end
if fm["audio"]
  a = fm["audio"]
  src = a.is_a?(Hash) ? a["src"] : a
  fails << "audio: has no src" if src.to_s.strip.empty?
  if src.to_s.start_with?("/")
    present = IO.popen(["git", "cat-file", "-e", "#{rev}:#{src.sub(%r{\A/}, '')}"], err: File::NULL, &:read) && $?.success?
    fails << "audio file #{src} isn't in the commit" unless rev.start_with?("file=") || present
  end
end

# 8. section and kind (HANDOFF "Sections and kinds"; values from _data/sections.yml and _data/kinds.yml)
data_dir = File.expand_path("../_data", __dir__)
if File.exist?("#{data_dir}/sections.yml") && File.exist?("#{data_dir}/kinds.yml")
  secs = YAML.load_file("#{data_dir}/sections.yml")
  kinds = YAML.load_file("#{data_dir}/kinds.yml").map { |k| k["slug"] }
  cats = Array(fm["categories"] || fm["category"])
  if cats.size != 1
    fails << "categories: must list exactly one section (one of #{secs.map { |s| s['slug'] }.join(', ')}); got #{cats.inspect}"
  elsif (sec = secs.find { |s| s["slug"] == cats.first.to_s }).nil?
    fails << "categories: #{cats.first.inspect} isn't a section (one of #{secs.map { |s| s['slug'] }.join(', ')})"
  elsif fm["subsection"]
    subs = (sec["subsections"] || []).map { |x| x["slug"] }
    fails << "subsection: #{fm['subsection'].inspect} isn't a subsection of #{sec['slug']} (allowed: #{subs.empty? ? 'none' : subs.join(', ')})" unless subs.include?(fm["subsection"].to_s)
  end
  fails << "kind: must be one of #{kinds.join(', ')}; got #{fm['kind'].inspect}" unless kinds.include?(fm["kind"].to_s)
  # YAML only types "YYYY-MM-DD HH:MM:SS" as a Time; Jekyll also accepts "YYYY-MM-DD HH:MM" (a String here).
  has_time = fm["date"].is_a?(Time) || fm["date"].to_s =~ /\A\d{4}-\d\d-\d\d[ T]\d{1,2}:\d\d/
  if fm["kind"].to_s == "news" && !has_time
    fails << "news items need `date: YYYY-MM-DD HH:MM` (UTC, with a time) so they order correctly on the home page"
  end
  fails << "description: is required (shown on the home and section pages)" if fm["description"].to_s.strip.empty?
end

cited_counts = sources.each_index.map { |i| markers.count { |m, _| m.to_i == i + 1 } }
puts "sources: #{sources.size}; inline links: #{links.size}; markers: #{markers.size} (per source: #{cited_counts.join(', ')})"
warns.each { |w| puts "WARN #{w}" }
fails.each { |f| puts "FAIL #{f}" }
puts(fails.empty? ? "OK: citations follow the house style" : "NOT OK: #{fails.size} problem(s)")
exit(fails.empty? ? 0 : 1)
