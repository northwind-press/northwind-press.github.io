# Self-test for check-citations.rb. Temp files only; never touches git state.
require "tmpdir"
dir = Dir.mktmpdir
FM = <<~Y
  ---
  title: "T"
  description: "D"
  categories: [ai]
  subsection: applied
  kind: feature
  sources:
    - title: "A"
      url: https://a.example/doc
    - title: "B"
      url: https://b.example/doc
  corrections: []
  ---
Y
OLD = FM + <<~B

  [Anthropic says caching works](https://a.example/doc). [Batches cost less](https://b.example/doc). [Entries last five minutes](https://a.example/doc).
B
GOOD = FM + <<~B

  [Anthropic says](https://a.example/doc) caching works. [Batches](https://b.example/doc) cost less. Entries last five minutes{% include cite.html n=1 %}.
B
cases = {
  "good revision" => [true, GOOD, true],
  "marker n out of range" => [false, GOOD.sub("n=1 %}", "n=3 %}"), false],
  "source linked twice" => [false, GOOD.sub("Entries last five minutes{% include cite.html n=1 %}", "[Entries last five minutes](https://a.example/doc)"), false],
  "source never linked" => [false, GOOD.sub("[Batches](https://b.example/doc)", "Batches{% include cite.html n=2 %}"), false],
  "link to URL not in sources" => [false, GOOD.sub("Entries last", "[Entries](https://x.example) last"), false],
  "marker inside straight quotes" => [false, GOOD.sub("Entries last five minutes{% include cite.html n=1 %}.", "It says \"entries last{% include cite.html n=1 %} five minutes\"."), false],
  "marker inside curly quotes" => [false, GOOD.sub("Entries last five minutes{% include cite.html n=1 %}.", "It says “entries last{% include cite.html n=1 %} five minutes”."), false],
  "marker after closing quote is fine" => [true, GOOD.sub("Entries last five minutes{% include cite.html n=1 %}.", "It says “entries last five minutes”{% include cite.html n=1 %}."), false],
  "two markers same source one sentence" => [false, GOOD.sub("Entries last five minutes{% include cite.html n=1 %}.", "Entries last{% include cite.html n=1 %} five minutes{% include cite.html n=1 %}."), false],
  "text changed vs old" => [false, GOOD.sub("five minutes", "ten minutes"), true],
  "quoted sentences each with a marker" => [true, GOOD + "\nIt says “A is true.”{% include cite.html n=1 %} “B is true.”{% include cite.html n=1 %}\n", false],
  "straight-quoted sentences each with a marker" => [true, GOOD + "\nIt says \"A is true.\"{% include cite.html n=1 %} \"B is true.\"{% include cite.html n=1 %}\n", false],
  "list items each with a marker" => [true, GOOD + "\n- **One.** A holds{% include cite.html n=1 %}.\n- **Two.** B holds{% include cite.html n=1 %}.\n", false],
  "sentence starting with code" => [true, GOOD + "\nA holds{% include cite.html n=1 %}. `x` also holds{% include cite.html n=1 %}.\n", false],
  "audio duration unquoted m:ss" => [false, GOOD.sub("corrections:", "audio:\n  src: https://cdn.example.org/a.mp3\n  duration: 12:34\ncorrections:"), false],
  "audio duration quoted" => [true, GOOD.sub("corrections:", "audio:\n  src: https://cdn.example.org/a.mp3\n  duration: \"12:34\"\ncorrections:"), false],
  "unknown section" => [false, GOOD.sub("categories: [ai]", "categories: [crypto]"), false],
  "two sections" => [false, GOOD.sub("categories: [ai]", "categories: [ai, security]"), false],
  "subsection under wrong section" => [false, GOOD.sub("categories: [ai]", "categories: [security]"), false],
  "unknown kind" => [false, GOOD.sub("kind: feature", "kind: opinion"), false],
  "news without a time" => [false, GOOD.sub("kind: feature", "kind: news\ndate: 2026-11-03"), false],
  "news with a time" => [true, GOOD.sub("kind: feature", "kind: news\ndate: 2026-11-03 14:05"), false],
  "markers in code are ignored" => [true, GOOD + "\n```\n{% include cite.html n=9 %}\n```\n", false],
}
File.write("#{dir}/old.md", OLD)
pass = true
cases.each do |name, (expect_ok, doc, against)|
  File.write("#{dir}/new.md", doc)
  args = ["ruby", File.join(__dir__, "check-citations.rb"), "file=#{dir}/new.md", "x"]
  args += ["--against", "file=#{dir}/old.md"] if against
  out = IO.popen(args, &:read)
  ok = $?.success?
  good = ok == expect_ok
  pass &&= good
  puts "#{good ? 'pass' : 'FAIL'}  #{name}: expected #{expect_ok ? 'OK' : 'reject'}, got #{ok ? 'OK' : 'reject'}"
  puts out.gsub(/^/, "      ") unless good
end
puts(pass ? "ALL TESTS PASS" : "SOME TESTS FAILED")
exit(pass ? 0 : 1)
