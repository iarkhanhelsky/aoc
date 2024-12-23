require 'set'

class Solution
  def count_groups(connections, roots)
    edges = {}
    connections.each do |t, k|
      edges[t] = (edges[t] || Array.new) << k
      edges[k] = (edges[k] || Array.new) << t
    end
    
    
    parties = Set.new
    roots.each do |k|
      edges[k].combination(2)
       .select {|e1, e2| edges[e1].include?(e2) }
       .each {|e1, e2| parties << [k, e1, e2].sort }
    end

    parties
  end

  def largest_party(connections)
    edges = {}
    connections.each do |t, k|
      edges[t] = (edges[t] || Array.new) << k
      edges[k] = (edges[k] || Array.new) << t
    end
    
    seed_parties = Set.new
    edges.each do |k, v|
      v.combination(2)
       .select {|e1, e2| edges[e1].include?(e2) }
       .each {|e1, e2| seed_parties << Set.new([k, e1, e2]) }
    end

    seed_parties.each do |p|
      queue = p.to_a
      while !queue.empty?
        e = queue.shift
        x = edges[e].find { |v| !p.include?(v) && p.all? { |k| edges[k].include?(v) } }
        if x 
          queue << x
          queue << e
          p << x
        end
      end
    end

    seed_parties.max_by {|e| e.size }.sort.join(',')
  end

  def run(lines)
    connections = lines.flat_map { |l| [l.split('-'), l.split('-').reverse] }
    yield count_groups(connections, connections.flatten.select {|n| n.start_with?('t') }).size
    yield largest_party(connections)
  end
end
