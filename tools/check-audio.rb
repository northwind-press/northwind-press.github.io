# Audio merge gate (HANDOFF "Steps" 5 / editor wiki v4). Merge only if this passes.
# Usage: ruby tools/check-audio.rb TEXT_SHA AUDIO_SHA PATH [--branch REF] [--repo DIR]
#   TEXT_SHA  = the editor's "Text approved" sha
#   AUDIO_SHA = the editor's "Audio approved" sha
#   PATH      = _posts/YYYY-MM-DD-slug.md
#   --branch  = check the branch tip equals AUDIO_SHA (e.g. origin/article/slug)
# Checks: tip; exactly one commit after the text sha; that commit touches only the post and its audio
# file; in the post only the `audio:` block was added (front matter otherwise and body byte-identical);
# audio fields complete; narrated_from == TEXT_SHA; duration format; file present, MP3, size limits.
require "yaml"
require "date"

args = ARGV.dup
opt = ->(name) { i = args.index(name); i ? args.slice!(i, 2)[1] : nil }
branch = opt.("--branch")
repo = opt.("--repo") || "."
text_sha, audio_sha, path = args
abort "usage: TEXT_SHA AUDIO_SHA PATH [--branch REF] [--repo DIR]" unless path

def git(repo, *a)
  out = IO.popen(["git", "-C", repo, *a], err: File::NULL, &:read)
  [out, $?.success?]
end
full = ->(rev) { o, ok = git(repo, "rev-parse", "--verify", "#{rev}^{commit}"); ok ? o.strip : nil }

fails = []
warns = []
t, a = full.(text_sha), full.(audio_sha)
fails << "text sha #{text_sha} not found" unless t
fails << "audio sha #{audio_sha} not found" unless a
if t && a
  if branch
    tip = full.(branch)
    fails << "branch #{branch} tip is #{tip&.slice(0, 7)}, not the audio-approved #{a[0, 7]}" unless tip == a
  end
  _, anc = git(repo, "merge-base", "--is-ancestor", t, a)
  fails << "text sha isn't an ancestor of the audio sha" unless anc
  n = git(repo, "rev-list", "--count", "#{t}..#{a}")[0].to_i
  fails << "expected exactly 1 commit after the text sha, found #{n}" unless n == 1

  split = lambda do |src|
    m = src.to_s.match(/\A---\n(.*?)\n---\n(.*)\z/m)
    m ? [m[1], m[2]] : [nil, nil]
  end
  old_src, = git(repo, "show", "#{t}:#{path}")
  new_src, = git(repo, "show", "#{a}:#{path}")
  ofm_raw, obody = split.(old_src)
  nfm_raw, nbody = split.(new_src)
  if ofm_raw.nil? || nfm_raw.nil?
    fails << "can't read front matter of #{path} at both shas"
  else
    ofm = YAML.safe_load(ofm_raw, [Date, Time])
    nfm = YAML.safe_load(nfm_raw, [Date, Time])
    fails << "body changed after text approval" if obody != nbody
    fails << "text-approved version already has an audio: block" if ofm.key?("audio")
    rest_new = nfm.reject { |k, _| k == "audio" }
    fails << "front matter changed outside the audio: block (#{(rest_new.keys | ofm.keys).reject { |k| rest_new[k] == ofm[k] }.join(', ')})" if rest_new != ofm
    # raw-text check too, so comments/formatting outside the block don't change either
    stripped = nfm_raw.sub(/^audio:\n(?:[ \t]+.*\n?)*/, "").sub(/\n+\z/, "")
    warns << "front matter text outside audio: differs in formatting" if stripped != ofm_raw.sub(/\n+\z/, "") && rest_new == ofm

    au = nfm["audio"]
    if !au.is_a?(Hash)
      fails << "audio: must be a block with src, duration, narrator, narrated_from (no shorthand)"
    else
      %w[src duration narrator narrated_from].each { |k| fails << "audio.#{k} is missing" if au[k].to_s.strip.empty? }
      nf = full.(au["narrated_from"].to_s)
      fails << "audio.narrated_from (#{au['narrated_from']}) doesn't match the text-approved sha #{t[0, 7]}" unless nf == t
      d = au["duration"]
      fails << "audio.duration must be a quoted \"m:ss\" or \"h:mm:ss\" (got #{d.inspect})" unless d.is_a?(String) && d =~ /\A\d{1,3}:[0-5]\d(:[0-5]\d)?\z/
      src = au["src"].to_s
      files, = git(repo, "diff", "--name-only", t, a)
      allowed = [path]
      if src.start_with?("/")
        file = src.sub(%r{\A/}, "")
        allowed << file
        fails << "audio file must be under assets/audio/" unless file.start_with?("assets/audio/")
        fails << "audio file should be named like the post (#{File.basename(path, '.md')}.mp3)" unless File.basename(file) == "#{File.basename(path, '.md')}.mp3"
        size, ok = git(repo, "cat-file", "-s", "#{a}:#{file}")
        if !ok
          fails << "audio file #{file} isn't in the audio commit"
        else
          mb = size.to_i / 1_048_576.0
          fails << format("audio file is %.1f MB; GitHub rejects files over 100 MB", mb) if mb > 100
          warns << format("audio file is %.1f MB; consider external hosting above ~25 MB", mb) if mb > 25 && mb <= 100
          puts format("audio file: %s (%.1f MB)", file, mb)
        end
        fails << "audio file must be .mp3" unless file.downcase.end_with?(".mp3")
      elsif src.start_with?("https://")
        warns << "external audio #{src}: reachability and content not checked"
      else
        fails << "audio.src must be /assets/audio/... or https://..."
      end
      extra = files.split("\n") - allowed
      fails << "audio commit also changes: #{extra.join(', ')}" unless extra.empty?
    end
  end
end

warns.each { |w| puts "WARN #{w}" }
fails.each { |f| puts "FAIL #{f}" }
puts(fails.empty? ? "OK: audio merge gate passes" : "NOT OK: #{fails.size} problem(s)")
exit(fails.empty? ? 0 : 1)
