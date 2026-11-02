# Self-test for check-link-revision.rb. Writes temp files only; never touches git state.
require "tmpdir"
dir = Dir.mktmpdir
orig = IO.popen(["git", "show", "13d2dd7:_posts/2026-11-02-batch-apis.md"], &:read)
fm_end = orig.index("\n---\n", 4) + 5
fm, body = orig[0...fm_end], orig[fm_end..]
urls = body.scan(/\]\(([^)\s]+)\)/).flatten.uniq
swap_from, swap_to = urls[0], urls[1]
# [expectation, mutated document]
cases = {
  "unchanged" => [true, orig],
  "updates: note added (style.md §5)" => [true, fm.sub(/---\n\z/, "updates:\n  - date: 2026-11-02\n    text: \"We replaced one source link.\"\n---\n") + body],
  "body text changed" => [false, fm + body.sub("1,000 requests", "2,000 requests")],
  "front matter changed" => [false, orig.sub("50%", "40%")],
  "URL changed to a new URL" => [false, fm + body.sub("#{swap_from})", "#{swap_from}-x)")],
  "URL swapped to another URL already in article" => [false, fm + body.sub("(#{swap_from})", "(#{swap_to})")],
  "link split at sentence, same URL" => [true, fm + body.sub(/\[([^\]]{40,}?)(\. )([^\]]+)\]\(([^)\s]+)\)/) { "[#{$1}](#{$4})#{$2}[#{$3}](#{$4})" }],
  "link narrowed to a short phrase" => [true, fm + body.sub(/\[([^\]\s]+ [^\]\s]+ [^\]\s]+)( [^\]]{20,})\]\(([^)\s]+)\)/) { "[#{$1}](#{$3})#{$2}" }],
  "link moved onto previously unlinked text" => [false, fm + body.sub(/([.!?] )([A-Z][a-z]+ [a-z]+)( [^\[\n]*?)\[([^\]]+)\]\(([^)\s]+)\)/) { "#{$1}[#{$2}](#{$5})#{$3}#{$4}" }],
}
File.write("#{dir}/orig.md", orig)
pass = true
cases.each do |name, (expect_ok, doc)|
  if doc == orig && name != "unchanged"
    puts "?? #{name}: mutation did not apply, test skipped"; pass = false; next
  end
  File.write("#{dir}/new.md", doc)
  out = IO.popen(["ruby", File.join(__dir__, "check-link-revision.rb"), "file=#{dir}/orig.md", "file=#{dir}/new.md", "x"], &:read)
  got_ok = $?.success?
  good = got_ok == expect_ok
  pass &&= good
  puts "#{good ? 'pass' : 'FAIL'}  #{name}: expected #{expect_ok ? 'OK' : 'reject'}, got #{got_ok ? 'OK' : 'reject'}"
  puts out.gsub(/^/, "      ") unless good
end
puts(pass ? "ALL TESTS PASS" : "SOME TESTS FAILED")
exit(pass ? 0 : 1)
