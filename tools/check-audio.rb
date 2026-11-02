# Audio merge gate (HANDOFF "Adding audio" C / editor wiki v5). Merge only if this passes.
# Usage: ruby tools/check-audio.rb TEXT_SHA AUDIO_SHA PATH [--branch REF] [--main REF] [--repo DIR]
#   TEXT_SHA  = the editor's "Text approved" sha (for a live post: its last approved commit on main)
#   AUDIO_SHA = the editor's "Audio approved" sha
#   PATH      = _posts/YYYY-MM-DD-slug.md
#   --branch  = check the branch tip equals AUDIO_SHA (e.g. origin/article/slug or origin/audio/slug)
#   --main    = the published branch, default origin/main (for the after-publication flow)
# If the post at AUDIO_SHA has no `audio:` field, the gate does not apply: exit 0 (text-only publishing).
# Otherwise AUDIO_SHA must be a single commit whose parent P is either
#   (a) TEXT_SHA itself (audio added on the article branch), or
#   (b) a commit on main that contains TEXT_SHA, with the post byte-identical at P and TEXT_SHA
#       (audio added later on audio/<slug> cut from main; nothing unreviewed in between).
# The commit may touch only the post and its audio file, and only the `audio:` block in the post.
# Also: fields complete; narrated_from == TEXT_SHA; duration format; file present, MP3, size limits.
require "yaml"
require "date"
require "fileutils"

args = ARGV.dup
opt = ->(name) { i = args.index(name); i ? args.slice!(i, 2)[1] : nil }
branch = opt.("--branch")
main_ref = opt.("--main") || "origin/main"
repo = opt.("--repo") || "."
live_path = (i = args.index("--live")) ? args.slice!(i, 2)[1] : nil
text_sha, audio_sha, path = args
abort "usage: TEXT_SHA AUDIO_SHA PATH [--branch REF] [--main REF] [--repo DIR]\n   or: --live _posts/FILE.md [--main REF]  (is the live post's audio still valid?)" unless path || live_path

def git(repo, *a)
  out = IO.popen(["git", "-C", repo, *a], err: File::NULL, &:read)
  [out, $?.success?]
end
# The post as narrated: drop the audio: block and the publication metadata that may change after text
# approval without re-narration (date:, placement:; handoff v12/v13). Top-level keys only: a source's
# indented `date:` is unaffected.
def narration_view(src)
  # Only the title and body are narrated (handoff "What is narrated"), so they're all that must match.
  # Other front matter (date, placement, categories, kind, description, sources, audio...) can change
  # without making the narration wrong.
  m = src.to_s.match(/\A---\n(.*?)\n---\n(.*)\z/m)
  return src.to_s unless m
  title = (YAML.safe_load(m[1], [Date, Time]) || {})["title"].to_s
  "title: #{title}\n---\n#{m[2]}"
end

# The post at REV: the same path, or, after a publish-time rename (date reset at merge), the file with the
# same slug.
def post_at(repo, rev, path)
  out, ok = git(repo, "show", "#{rev}:#{path}")
  return out if ok
  slug = File.basename(path).sub(/\A\d{4}-\d\d-\d\d-/, "")
  list, = git(repo, "ls-tree", "--name-only", "#{rev}:_posts")
  cand = list.to_s.split("\n").find { |f| f.sub(/\A\d{4}-\d\d-\d\d-/, "") == slug }
  cand ? git(repo, "show", "#{rev}:_posts/#{cand}")[0] : nil
end

full = ->(rev) { o, ok = git(repo, "rev-parse", "--verify", "#{rev}^{commit}"); ok ? o.strip : nil }

# --live: is a published post's audio still valid? Compares the narrated parts (title + body) of the post
# on main with the post at its audio.narrated_from. Use after any front-matter or text change to a post with
# audio. It isn't a merge gate: it checks no commit structure.
if live_path
  mref = full.(main_ref) or abort "#{main_ref} not found (git fetch first)"
  live = post_at(repo, mref, live_path) or abort "#{live_path} not found on #{main_ref}"
  fm = YAML.safe_load(live[/\A---\n(.*?)\n---\n/m, 1].to_s, [Date, Time]) || {}
  au = fm["audio"]
  unless au.is_a?(Hash) && au["narrated_from"]
    puts "No audio: block with narrated_from in #{live_path}; nothing to check."
    exit 0
  end
  nf = full.(au["narrated_from"].to_s) or abort "narrated_from #{au['narrated_from']} not found"
  narrated = post_at(repo, nf, live_path)
  if narrated && narration_view(narrated) == narration_view(live)
    puts "OK: audio still matches. Title and body on #{main_ref} (#{mref[0, 7]}) are identical to narrated_from #{nf[0, 7]}."
    exit 0
  end
  puts "NOT OK: the title or body on #{main_ref} (#{mref[0, 7]}) differs from narrated_from #{nf[0, 7]}. Re-record, or add an audio_note (handoff: Audio → Corrections)."
  exit 1
end

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
  new_src, = git(repo, "show", "#{a}:#{path}")
  new_fm_raw = new_src.to_s[/\A---\n(.*?)\n---\n/m, 1]
  if new_fm_raw && !(YAML.safe_load(new_fm_raw, [Date, Time]) || {}).key?("audio")
    puts "No audio: field in #{path} at #{a[0, 7]}. The audio gate doesn't apply; publish on text approval + check-citations."
    exit 0
  end

  parents = git(repo, "rev-list", "--parents", "-n", "1", a)[0].split[1..] || []
  fails << "the audio commit must be a single commit with one parent (has #{parents.size})" unless parents.size == 1
  p_sha = parents.first
  if p_sha && p_sha != t
    mref = full.(main_ref)
    on_main = mref && git(repo, "merge-base", "--is-ancestor", p_sha, mref)[1]
    has_text = git(repo, "merge-base", "--is-ancestor", t, p_sha)[1]
    # Ignore an existing audio: block, so a re-record on top of an earlier audio commit is allowed.
    same_post = narration_view(post_at(repo, p_sha, path)) == narration_view(post_at(repo, t, path))
    if on_main && has_text && same_post
      puts "after-publication flow: audio commit sits on #{main_ref} commit #{p_sha[0, 7]}; post unchanged since text sha #{t[0, 7]}"
    else
      why = []
      why << "its parent #{p_sha[0, 7]} isn't the text sha and isn't on #{main_ref}" unless on_main
      why << "the text sha isn't in its history" unless has_text
      why << "the post changed between the text sha and the audio commit's parent" unless same_post
      fails << "audio commit isn't directly on the approved text: #{why.join('; ')}"
    end
  end
  base = p_sha || t

  # The live post must still be the narrated text. A branch cut from an older main can pass every
  # check above while main has since moved on (e.g. a wording fix), so compare against current main
  # too. Any existing audio: block is ignored, so re-records work. Run `git fetch` first.
  mref_now = full.(main_ref)
  if mref_now
    live, live_ok = git(repo, "show", "#{mref_now}:#{path}")
    if live_ok
      if narration_view(live) != narration_view(post_at(repo, t, path))
        fails << "the post on #{main_ref} (#{mref_now[0, 7]}) differs from the narrated text #{t[0, 7]}: merging would attach audio of an older or different text"
      else
        puts "live post on #{main_ref} #{mref_now[0, 7]} matches the narrated text"
      end
    end
  else
    warns << "#{main_ref} not found: couldn't compare with the live post"
  end

  split = lambda do |src|
    m = src.to_s.match(/\A---\n(.*?)\n---\n(.*)\z/m)
    m ? [m[1], m[2]] : [nil, nil]
  end
  old_src, = git(repo, "show", "#{base}:#{path}")
  ofm_raw, obody = split.(old_src)
  nfm_raw, nbody = split.(new_src)
  if ofm_raw.nil? || nfm_raw.nil?
    fails << "can't read front matter of #{path} at both shas"
  else
    ofm = YAML.safe_load(ofm_raw, [Date, Time])
    nfm = YAML.safe_load(nfm_raw, [Date, Time])
    fails << "body changed after text approval" if obody != nbody
    # An existing audio: block (re-record after a correction) may be replaced; nothing else may change.
    rest_new = nfm.reject { |k, _| k == "audio" }
    rest_old = ofm.reject { |k, _| k == "audio" }
    fails << "front matter changed outside the audio: block (#{(rest_new.keys | rest_old.keys).reject { |k| rest_new[k] == rest_old[k] }.join(', ')})" if rest_new != rest_old
    # raw-text check too, so comments/formatting outside the block don't change either
    strip_audio = ->(raw) { raw.sub(/^audio:\n(?:[ \t]+.*\n?)*/, "").sub(/\n+\z/, "") }
    warns << "front matter text outside audio: differs in formatting" if strip_audio.(nfm_raw) != strip_audio.(ofm_raw) && rest_new == rest_old

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
      files, = git(repo, "diff", "--name-only", base, a)
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
          # Mechanical cross-check (not a narration check): real duration vs stated, and speaking rate.
          if ENV["CHECK_AUDIO_SKIP_AFINFO"] # structural self-tests use fake MP3 bytes
            warns << "afinfo check skipped (CHECK_AUDIO_SKIP_AFINFO)"
          elsif system("which afinfo > /dev/null 2>&1")
            tmp = File.expand_path(".render/check-audio-#{a[0, 7]}#{File.extname(file)}")
            FileUtils.mkdir_p(File.dirname(tmp))
            File.binwrite(tmp, IO.popen(["git", "-C", repo, "show", "#{a}:#{file}"], "rb", &:read))
            info = IO.popen(["afinfo", tmp], err: File::NULL, &:read).to_s
            real = info[/estimated duration:\s*([\d.]+)/, 1]&.to_f
            fmt = info[/Data format:\s*(.+)/, 1].to_s.strip
            bitrate = info[/bit rate:\s*(\d+)/, 1]
            if real.nil? || real <= 0
              fails << "afinfo can't read #{file} as audio"
            else
              stated = d.to_s.split(":").map(&:to_i).reverse.each_with_index.sum { |v, i| v * 60**i }
              puts format("  afinfo: %.0f s (stated %s = %d s); %s%s", real, d, stated, fmt, bitrate ? "; #{bitrate.to_i / 1000} kbps" : "")
              fails << format("real duration %.0f s differs from stated %s by more than 5 s", real, d) if stated > 0 && (real - stated).abs > 5
              # Spoken-word estimate under the v6 narration rules: tables and code blocks are replaced by a
              # one-sentence description (~15 words each); inline code is said as its parts
              # ("output_config.format" -> "output config dot format"); markers, URLs, Sources not read.
              body = nbody.to_s.gsub(/\{%.*?%\}/m, "").gsub(/\[([^\]]*)\]\([^)]*\)/, '\1')
              blocks = 0
              body = body.gsub(/^(```|~~~).*?^\1[^\n]*$/m) { blocks += 1; " " }
              tables = body.scan(/(?:^\s*\|.*\n?)+/).size
              body = body.lines.reject { |l| l.lstrip.start_with?("|") }.join
              code_words = 0
              body = body.gsub(/`([^`\n]+)`/) do
                code = Regexp.last_match(1) # capture first: split/scan below reset $1
                code_words += code.split(/[^A-Za-z0-9]+/).reject(&:empty?).size + code.scan(/[.\/:]/).size
                " "
              end
              prose = (nfm["title"].to_s + " " + body.gsub(/[#*|>_]/, " ")).split.size
              words = prose + code_words + 15 * (tables + blocks)
              wpm = words / (real / 60.0)
              puts format("  ~%d spoken words (prose %d + inline code %d + %d table/code descriptions × 15) -> %.0f words/min",
                          words, prose, code_words, tables + blocks, wpm)
              # Wide band on purpose: synthetic voices run ~110–160 wpm and the spoken count is an
              # estimate. Truncated or heavily cut audio shows up far above it, long additions far below.
              warns << format("%.0f words/min is outside 100–200: possible truncation, large cuts or additions, or wrong file", wpm) unless wpm.between?(100, 200)
            end
            File.delete(tmp) if File.exist?(tmp)
          else
            warns << "afinfo not available: real duration and speaking rate not checked"
          end
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
