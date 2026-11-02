# Static Liquid sanity check (no Liquid engine available locally): delimiters and block tags balance,
# and blocks close in the right order. Usage: ruby tools/check-liquid.rb FILE...
ok = true
ARGV.each do |f|
  s = File.read(f)
  open_d, close_d = s.scan(/\{%/).size, s.scan(/%\}/).size
  out_o, out_c = s.scan(/\{\{/).size, s.scan(/\}\}/).size
  stack = []
  errs = []
  blocks = %w[if unless case for capture comment raw]
  in_comment = false
  s.scan(/\{%-?\s*(\w+)/).flatten.each do |tag|
    if in_comment
      if tag == "endcomment"
        in_comment = false
        stack.pop
      end
      next
    end
    if blocks.include?(tag)
      stack << tag
      in_comment = true if tag == "comment"
    elsif tag.start_with?("end")
      want = tag.sub("end", "")
      if stack.last == want then stack.pop else errs << "#{tag} closes #{stack.last.inspect}" end
    end
  end
  errs << "unclosed: #{stack.join(', ')}" unless stack.empty?
  errs << "{% #{open_d} vs %} #{close_d}" if open_d != close_d
  errs << "{{ #{out_o} vs }} #{out_c}" if out_o != out_c
  puts "#{f}: #{errs.empty? ? 'OK' : errs.join('; ')}"
  ok &&= errs.empty?
end
exit(ok ? 0 : 1)
