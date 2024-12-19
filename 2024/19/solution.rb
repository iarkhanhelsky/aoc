require 'set'

class Solution
  def combinations(pattern, towels, visited = {})
    variants = [pattern]

    count = 0
    while !variants.empty?
      variants.sort_by! { |v| v.size }
      cur = variants.shift
      # next if visited.include?(cur)
      # visited[cur] = accumulated

      # p [pattern, cur, variants.size]
      if cur == ''
        count += 1
        next
      end

      towels.select {|t| cur.start_with?(t) }
            .map {|t| cur[t.size..] }
            .each do |v| 
              if !visited.include?(v)
                visited[v] = combinations(v, towels, visited)
              end

              count += visited[v]
            end
    end  

    count
  end

  def run(lines)
    towels = lines[0].split(', ')
    yield lines[2..].select { |p| combinations(p, towels) > 0 }.size
    yield lines[2..].inject(0) {|acc, elem| acc + combinations(elem, towels) }
  end
end
