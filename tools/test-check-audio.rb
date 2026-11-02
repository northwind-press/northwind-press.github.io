# Self-test for check-audio.rb using a throwaway git repo under .render/ (gitignored).
require "fileutils"
R = File.expand_path(".render/audio-gate-repo")
GD = File.expand_path(".render/audio-gate-gitdir")
FileUtils.rm_rf([R, GD])
FileUtils.mkdir_p(R)
# The sandbox forbids writing any */.git/config, so keep the test repo's git data in a plain directory.
# check-audio.rb inherits these and its `git -C` calls use them.
ENV["GIT_DIR"] = GD
ENV["GIT_WORK_TREE"] = R
def g(*a)
  system("git", "-C", R, "-c", "user.name=t", "-c", "user.email=t@t", "-c", "commit.gpgsign=false", *a, out: File::NULL, err: File::NULL) || abort("git #{a.join(' ')} failed")
end
POST = "_posts/2026-11-05-example.md"
FM = "---\ntitle: \"Example\"\nsources:\n  - title: \"A\"\n    url: https://a.example\ncorrections: []\n---\n"
BODY = "Body text.\n"
def write(rel, s)
  FileUtils.mkdir_p(File.dirname("#{R}/#{rel}"))
  File.write("#{R}/#{rel}", s)
end
g("init", "-q", "--template=", "-b", "main") # no hook templates (the sandbox blocks writing .git/hooks)
write(POST, FM + BODY); g("add", "-A"); g("commit", "-qm", "text")
TEXT = IO.popen(["git", "-C", R, "rev-parse", "HEAD"], &:read).strip
def audio_block(nf, dur = '"11:42"', src = "/assets/audio/2026-11-05-example.mp3")
  "audio:\n  src: #{src}\n  duration: #{dur}\n  narrator: \"N\"\n  narrated_from: #{nf}\n"
end
def scenario(name)
  g("checkout", "-q", "-B", name, TEXT)
  yield
  g("add", "-A"); g("commit", "-qm", name)
  IO.popen(["git", "-C", R, "rev-parse", "HEAD"], &:read).strip
end
add_ok = -> { write("assets/audio/2026-11-05-example.mp3", "ID3fake"); write(POST, FM.sub("---\n", "---\n").sub(/---\n\z/, audio_block(TEXT) + "---\n") + BODY) }
cases = {
  "good" => [true, -> { add_ok.() }],
  "narrated_from wrong" => [false, -> { write("assets/audio/2026-11-05-example.mp3", "x"); write(POST, FM.sub(/---\n\z/, audio_block("0000000") + "---\n") + BODY) }],
  "body changed" => [false, -> { add_ok.(); write(POST, File.read("#{R}/#{POST}").sub("Body text.", "Body text!")) }],
  "other file touched" => [false, -> { add_ok.(); write("README.md", "x") }],
  "unquoted duration" => [false, -> { write("assets/audio/2026-11-05-example.mp3", "x"); write(POST, FM.sub(/---\n\z/, audio_block(TEXT, "11:42") + "---\n") + BODY) }],
  "audio file missing" => [false, -> { write(POST, FM.sub(/---\n\z/, audio_block(TEXT) + "---\n") + BODY) }],
  "front matter changed elsewhere" => [false, -> { add_ok.(); write(POST, File.read("#{R}/#{POST}").sub('"Example"', '"Changed"')) }],
}
pass = true
cases.each do |name, (expect_ok, setup)|
  sha = scenario(name.tr(" ", "-"), &setup)
  out = IO.popen(["ruby", File.join(__dir__, "check-audio.rb"), TEXT, sha, POST, "--repo", R, "--branch", name.tr(" ", "-")], &:read)
  ok = $?.success?
  good = ok == expect_ok
  pass &&= good
  puts "#{good ? 'pass' : 'FAIL'}  #{name}: expected #{expect_ok ? 'OK' : 'reject'}, got #{ok ? 'OK' : 'reject'}"
  puts out.gsub(/^/, "      ") unless good
end
# two commits after text approval
g("checkout", "-q", "-B", "two-commits", TEXT); add_ok.(); g("add", "-A"); g("commit", "-qm", "a"); write("assets/audio/2026-11-05-example.mp3", "ID3v2"); g("add", "-A"); g("commit", "-qm", "b")
sha = IO.popen(["git", "-C", R, "rev-parse", "HEAD"], &:read).strip
out = IO.popen(["ruby", File.join(__dir__, "check-audio.rb"), TEXT, sha, POST, "--repo", R], &:read)
good = !$?.success?; pass &&= good
puts "#{good ? 'pass' : 'FAIL'}  two commits after text approval: expected reject, got #{good ? 'reject' : 'OK'}"
# tip moved past the approved audio sha
g("checkout", "-q", "-B", "tip-moved", TEXT); add_ok.(); g("add", "-A"); g("commit", "-qm", "a")
approved = IO.popen(["git", "-C", R, "rev-parse", "HEAD"], &:read).strip
write("README.md", "late"); g("add", "-A"); g("commit", "-qm", "late")
out = IO.popen(["ruby", File.join(__dir__, "check-audio.rb"), TEXT, approved, POST, "--repo", R, "--branch", "tip-moved"], &:read)
good = !$?.success?; pass &&= good
puts "#{good ? 'pass' : 'FAIL'}  branch tip moved past approved sha: expected reject, got #{good ? 'reject' : 'OK'}"
puts(pass ? "ALL AUDIO GATE TESTS PASS" : "SOME AUDIO GATE TESTS FAILED")
exit(pass ? 0 : 1)
