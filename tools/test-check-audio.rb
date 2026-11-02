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
ENV["CHECK_AUDIO_SKIP_AFINFO"] = "1" # structural tests use fake MP3 bytes; the afinfo path is tested at the end
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
gate = lambda do |text, sha, *extra|
  IO.popen(["ruby", File.join(__dir__, "check-audio.rb"), text, sha, POST, "--repo", R, *extra], &:read)
  $?.success?
end
head = -> { IO.popen(["git", "-C", R, "rev-parse", "HEAD"], &:read).strip }
check = lambda do |name, expect_ok, ok|
  good = ok == expect_ok
  pass &&= good
  puts "#{good ? 'pass' : 'FAIL'}  #{name}: expected #{expect_ok ? 'OK' : 'reject'}, got #{ok ? 'OK' : 'reject'}"
end
# post without audio: gate doesn't apply
check.("no audio: field (text-only publishing)", true, gate.(TEXT, TEXT, "--main", "main"))
# after publication: main moves on (other post merged), audio/<slug> cut from main later
g("checkout", "-q", "main"); write("_posts/2026-11-06-other.md", "---\ntitle: o\n---\nx\n"); g("add", "-A"); g("commit", "-qm", "other post")
main_tip = head.()
g("checkout", "-q", "-B", "audio-later", main_tip); add_ok.(); g("add", "-A"); g("commit", "-qm", "audio later")
check.("after publication, audio branch from main", true, gate.(TEXT, head.(), "--main", "main", "--branch", "audio-later"))
# after publication, but an unreviewed commit sits between main and the audio commit
g("checkout", "-q", "-B", "audio-sneaky", main_tip); write("README.md", "sneaky"); g("add", "-A"); g("commit", "-qm", "sneaky")
add_ok.(); g("add", "-A"); g("commit", "-qm", "audio")
check.("after publication with an unreviewed commit before audio", false, gate.(TEXT, head.(), "--main", "main"))
# after publication, but the post changed on main since the editor's text sha (e.g. a correction)
g("checkout", "-q", "main"); write(POST, File.read("#{R}/#{POST}").sub("Body text.", "Corrected body text.")); g("add", "-A"); g("commit", "-qm", "correction")
g("checkout", "-q", "-B", "audio-stale", head.()); write("assets/audio/2026-11-05-example.mp3", "ID3"); write(POST, File.read("#{R}/#{POST}").sub(/---\n(?=Corrected)/, audio_block(TEXT) + "---\n")); g("add", "-A"); g("commit", "-qm", "audio stale")
check.("after publication, narrated from a pre-correction sha", false, gate.(TEXT, head.(), "--main", "main"))
# stale branch: audio cut from an older main (post == text there), but main has since changed the post
g("checkout", "-q", "-B", "audio-oldbase", main_tip); add_ok.(); g("add", "-A"); g("commit", "-qm", "audio on old main")
stale = head.()
check.("audio cut from older main, live post changed since", false, gate.(TEXT, stale, "--main", "main"))
puts(pass ? "ALL AUDIO GATE TESTS PASS" : "SOME AUDIO GATE TESTS FAILED")
exit(pass ? 0 : 1)
