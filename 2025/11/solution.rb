require 'set'

class Solution

  def unique_paths(connections, start, finish)
    q = [[start]]
    r = []
    while !q.empty?
      c = q.pop

      (connections[c.last] || []).each do |n|
        np = c + [n]

        if n == finish
          r << np
        elsif !c.include?(n)
          q << (np)
        end
      end
    end

    r
  end

  def run(lines)
    connections = lines.map { |l| input, outputs = l.split(':'); [input, outputs.split(' ')] }
    connections = connections.inject({}) { |a, c| a.update(c.first => c.last) }
    
    yield unique_paths(connections, 'you', 'out').size
  end
end
