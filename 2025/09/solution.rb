class Solution
  def run(lines)
    points = lines.map { |l| l.split(',').map(&:to_i) }

    yield points.combination(2)
                .map { |x, y| (x.first - y.first + 1).abs * (x.last - y.last + 1).abs }
                .max
  end
end
