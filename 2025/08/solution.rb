require 'set'

class Solution
  def distance(a, b)
    a.zip(b).map {|x, y| (x - y)**2 }.sum
  end

  def result(connections)
    r = connections.values.uniq.sort_by {|s| -s.size }
    r[..2].map {|s| s.size }.inject(&:*)
  end

  def run(lines)
    boxes = lines.map { |l| l.split(',').map(&:to_i) }
    pairs = boxes.combination(2).sort_by { |b1, b2| distance(b1, b2) }
    connections = boxes.inject({}) { |a, b| a.update(b => Set.new([b]))}

    pairs.each_with_index do |pair, it|
      b1, b2 = *pair
      # Part I
      yield "it:#{"%-4d" % it}  :: #{result(connections)}" if [10, 1000].include?(it)

      circuit = connections[b1] | connections[b2]
      circuit.each { |e| connections[e] = circuit }

      # Part II
      if circuit.size == boxes.size
        yield "con:#{"%-4d" % it} :: #{b1.first * b2.first}"
        break
      end
    end
  end
end
