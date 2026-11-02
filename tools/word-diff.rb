# Word-level diff of an article's visible text between two revisions (links and cite markers stripped,
# front matter compared separately). Usage: ruby tools/word-diff.rb OLD_REV NEW_REV PATH
old_rev, new_rev, path = ARGV
abort "usage: OLD NEW PATH" unless path
LINK = /\[((?:[^\[\]]|\[[^\]]*\])*)\]\(([^)\s]+)\)/
CITE = /\{%-?\s*include\s+cite\.html\s+n=\S+?\s*-?%\}/
def src(rev, path)
  IO.popen(["git", "show", "#{rev}:#{path}"], &:read)
end
def parts(s)
  m = s.match(/\A---\n(.*?)\n---\n(.*)\z/m)
  t = m[2].gsub(CITE, "")
  t = t.gsub(LINK) { $1 } while t =~ LINK
  [m[1], t.split(/\s+/).reject(&:empty?)]
end
ofm, ow = parts(src(old_rev, path))
nfm, nw = parts(src(new_rev, path))
puts(ofm == nfm ? "front matter: unchanged" : "front matter: CHANGED")
# LCS diff on words
n, m = ow.size, nw.size
dp = Array.new(n + 1) { Array.new(m + 1, 0) }
(n - 1).downto(0) { |i| (m - 1).downto(0) { |j| dp[i][j] = ow[i] == nw[j] ? dp[i + 1][j + 1] + 1 : [dp[i + 1][j], dp[i][j + 1]].max } }
i = j = 0
changes = []
while i < n || j < m
  if i < n && j < m && ow[i] == nw[j] then i += 1; j += 1
  elsif j < m && (i == n || dp[i][j + 1] >= dp[i + 1][j]) then changes << [:add, j, nw[j]]; j += 1
  else changes << [:del, i, ow[i]]; i += 1
  end
end
dels = changes.select { |c| c[0] == :del }.map { |c| c[2] }
adds = changes.select { |c| c[0] == :add }.map { |c| c[2] }
puts "words removed (#{dels.size}): #{dels.join('  ')}"
puts "words added (#{adds.size}): #{adds.join('  ')}"
changes.select { |c| c[0] == :del }.first(4).each { |_, k, _| puts "  context: …#{ow[[k - 6, 0].max..k + 4].join(' ')}…" }
