# Verify a "link-only" article revision (editor rule, 2026-11-02):
# - front matter unchanged
# - visible text unchanged (links stripped)
# - every linked character in the new version was linked to the SAME URL in the old one
#   (links may shrink or split; they may not move to new text or change URL)
# - every URL linked before is still linked somewhere
# Usage: ruby tools/check-link-revision.rb OLD_REV NEW_REV PATH
#        (a rev of the form file=/path reads a local file, for tests)
old_rev, new_rev, path = ARGV
abort "usage: OLD_REV NEW_REV PATH" unless path

def show(rev, path)
  return File.read(rev.sub("file=", "")) if rev.start_with?("file=")
  out = IO.popen(["git", "show", "#{rev}:#{path}"], &:read)
  abort "cannot read #{rev}:#{path}" unless $?.success?
  out
end

LINK = /\[((?:[^\[\]]|\[[^\]]*\])*)\]\(([^)\s]+)\)/

def split(src)
  m = src.match(/\A---\n(.*?)\n---\n(.*)\z/m) or abort "no front matter"
  [m[1], m[2]]
end

# Returns [plain_text, per-character URL array (nil where unlinked), links]
def flatten(body)
  text = +""
  map = []
  links = []
  pos = 0
  body.scan(LINK) do
    m = Regexp.last_match
    before = body[pos...m.begin(0)]
    text << before; map.concat([nil] * before.size)
    inner, url = m[1], m[2]
    text << inner; map.concat([url] * inner.size)
    links << [inner, url]
    pos = m.end(0)
  end
  rest = body[pos..] || ""
  text << rest; map.concat([nil] * rest.size)
  [text, map, links]
end

ofm, obody = split(show(old_rev, path))
nfm, nbody = split(show(new_rev, path))
ot, om, ol = flatten(obody)
nt, nm, nl = flatten(nbody)
ok = true

if ofm != nfm
  ok = false; puts "FAIL front matter changed"
end

if ot != nt
  ok = false
  i = (0...[ot.size, nt.size].min).find { |k| ot[k] != nt[k] } || [ot.size, nt.size].min
  puts "FAIL visible text differs at char #{i}:\n  old: ...#{ot[[i - 40, 0].max, 100].inspect}\n  new: ...#{nt[[i - 40, 0].max, 100].inspect}"
else
  bad = (0...nt.size).select { |k| nm[k] && nm[k] != om[k] }
  unless bad.empty?
    ok = false
    k = bad.first
    puts "FAIL #{bad.size} linked chars point to a different URL than before (or were unlinked before); first at char #{k}:"
    puts "  text: #{nt[[k - 20, 0].max, 80].inspect}"
    puts "  old URL: #{om[k].inspect}\n  new URL: #{nm[k].inspect}"
  end
end

dropped = om.compact.uniq - nm.compact.uniq
unless dropped.empty?
  ok = false
  dropped.each { |u| puts "FAIL URL no longer linked anywhere: #{u}" }
end

stats = ->(l) { [l.size, l.sum { |t, _| t.size }, l.map { |t, _| t.size }.max || 0] }
a, b = stats.(ol), stats.(nl)
puts "links: #{a[0]} -> #{b[0]}; linked chars: #{a[1]} -> #{b[1]}; longest link: #{a[2]} -> #{b[2]}"
puts(ok ? "OK: link-only revision" : "NOT link-only")
exit(ok ? 0 : 1)
