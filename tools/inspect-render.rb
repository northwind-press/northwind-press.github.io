# Static checks on a locally rendered post (tools/render-post.js output). No browser needed.
# Usage: ruby tools/inspect-render.rb .render/so/light.html
html = File.read(ARGV[0])
cites = html.scan(/<sup class="cite">.*?<\/sup>/)
anchors = html.scan(/id="cite-(\d+)"/).flatten
targets = html.scan(/<sup class="cite"><a href="#source-(\d+)"/).flatten.uniq
puts "citation markers: #{cites.size}; sample: #{cites.first}"
puts "first-use anchors: #{anchors.size} (duplicates: #{anchors.size - anchors.uniq.size})"
puts "cited sources: #{targets.sort_by(&:to_i).join(',')}; missing #source-N targets: #{targets.reject { |n| html.include?(%(id="source-#{n}")) }.inspect}"
backs = html.scan(/class="cite-back" href="#cite-(\d+)"/).flatten
puts "back links: #{backs.size}; back links without anchor: #{(backs - anchors).inspect}"
puts "adjacent citation pairs: #{html.scan(%r{</sup><sup class="cite">}).size}"
puts "citations inside table cells: #{html.scan(/<td>(?:(?!<\/td>).)*<sup class="cite">/m).size}"
puts "citations inside headings: #{html.scan(/<h[1-6][^>]*>(?:(?!<\/h).)*class="cite"/m).size}"
puts "leftover Liquid: #{html.scan(/\{%|\{\{/).size}"
all_ids = html.scan(/\bid="([^"]+)"/).flatten
puts "duplicate ids on page: #{(all_ids.group_by(&:itself).select { |_, v| v.size > 1 }.keys).inspect}"
puts "aria-labels (first 3): #{html.scan(/aria-label="(Source \d+)"/).flatten.first(3).join(' | ')}"
