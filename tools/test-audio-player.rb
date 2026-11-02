# Fixture test for the audio player via the local renderer (an approximation of Jekyll, see render-post.js).
# Writes into .render/audio-test (gitignored). Usage: ruby tools/test-audio-player.rb
require "fileutils"
dir = ".render/audio-test"
FileUtils.mkdir_p(dir)
base = IO.popen(["git", "show", "HEAD:_posts/2026-11-02-batch-apis.md"], &:read)
inject = ->(yaml) { base.sub(/\ncorrections:/, "\n#{yaml}\ncorrections:") }
cases = {
  "full" => [inject.("audio:\n  src: /assets/audio/2026-11-02-batch-apis.mp3\n  duration: \"12:34\"\n  narrator: \"Staff Writer\""), false],
  "shorthand" => [inject.("audio: /assets/audio/2026-11-02-batch-apis.mp3"), false],
  "external-hms" => [inject.("audio:\n  src: https://cdn.example.org/ep1.m4a?v=2\n  duration: \"1:02:03\""), false],
  "seconds" => [inject.("audio:\n  src: /assets/audio/x.mp3\n  duration: 754"), false],
  "none" => [base, true],
}
pass = true
cases.each do |name, (doc, expect_none)|
  post = "#{dir}/#{name}.md"
  File.write(post, doc)
  system("node", "tools/render-post.js", post, "#{dir}/#{name}", out: File::NULL) or (puts "render failed: #{name}"; pass = false; next)
  args = ["ruby", "tools/inspect-audio.rb", "#{dir}/#{name}/light.html"]
  args << "--expect-none" if expect_none
  out = IO.popen(args, &:read)
  ok = $?.success?
  pass &&= ok
  puts "== #{name}: #{ok ? 'pass' : 'FAIL'}"
  puts out.gsub(/^/, "   ")
end
puts(pass ? "ALL AUDIO FIXTURES PASS" : "SOME AUDIO FIXTURES FAILED")
exit(pass ? 0 : 1)
