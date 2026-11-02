# Static checks on the audio player in a locally rendered post (tools/render-post.js output).
# Usage: ruby tools/inspect-audio.rb RENDERED.html [--expect-none]
html = File.read(ARGV[0])
blocks = html.scan(/<section class="audio".*?<\/section>/m)
if ARGV[1] == "--expect-none"
  bad = blocks.any? || html.include?('id="article-text"') || html =~ /<audio\b/
  puts(bad ? "FAIL: audio markup present on a post without audio:" : "OK: no audio markup")
  exit(bad ? 1 : 0)
end
fails = []
fails << "expected exactly 1 audio section, found #{blocks.size}" unless blocks.size == 1
b = blocks.first.to_s
audio = b[/<audio\b[^>]*>/].to_s
fails << "audio lacks controls" unless audio.include?("controls")
fails << "audio lacks preload=\"none\"" unless audio.include?('preload="none"')
fails << "audio has autoplay" if audio.include?("autoplay")
fails << "audio not labelled by the heading" unless audio.include?('aria-labelledby="audio-heading"') && b.include?('id="audio-heading"')
fails << "label text missing" unless b.include?("Listen to this article")
src = b[/<source src="([^"]+)"/, 1]
fails << "no <source src>" unless src
dl = b[/<a href="([^"]+)" download>/, 1]
fails << "download link missing or points elsewhere (#{dl.inspect} vs #{src.inspect})" unless dl && dl == src
fails << "fallback link inside <audio> missing" unless b[/<audio.*?<a href="#{Regexp.escape(src.to_s)}">.*?<\/audio>/m]
fails << "transcript link missing" unless b.include?('href="#article-text"')
fails << "transcript target #article-text missing" unless html.include?('id="article-text"')
ids = html.scan(/\bid="([^"]+)"/).flatten
dups = ids.group_by(&:itself).select { |_, v| v.size > 1 }.keys
fails << "duplicate ids: #{dups.inspect}" unless dups.empty?
pos_audio, pos_body = html.index('<section class="audio"'), html.index('<div class="post-body"')
fails << "player is not between header and body" unless pos_audio && pos_body && pos_audio < pos_body
puts "label: #{b[/<h2[^>]*>(.*?)<\/h2>/m, 1].to_s.gsub(/<[^>]+>/, '')}"
puts "duration markup: #{b[/<time[^>]*>[^<]*<\/time>/] || '(none)'}"
puts "narrator: #{b[/Read by ([^<]+)/, 1] || '(none)'}; source: #{src} #{b[/type="([^"]+)"/, 1]}"
fails.each { |f| puts "FAIL #{f}" }
puts(fails.empty? ? "OK: audio player markup" : "NOT OK")
exit(fails.empty? ? 0 : 1)
