# Run check-citations on every post at a revision (default HEAD). Prints one line per post plus any FAIL/WARN.
# Usage: ruby tools/check-all-posts.rb [REV]
rev = ARGV[0] || "HEAD"
posts = IO.popen(["git", "ls-tree", "--name-only", "#{rev}:_posts"], &:read).split("\n").grep(/\.md\z/)
bad = 0
posts.each do |f|
  out = IO.popen(["ruby", File.join(__dir__, "check-citations.rb"), rev, "_posts/#{f}"], &:read)
  ok = $?.success?
  bad += 1 unless ok
  puts "#{ok ? 'OK  ' : 'FAIL'} #{f}"
  out.lines.grep(/^(FAIL|WARN)/).each { |l| puts "       #{l}" }
end
puts "#{posts.size - bad}/#{posts.size} posts pass"
exit(bad.zero? ? 0 : 1)
