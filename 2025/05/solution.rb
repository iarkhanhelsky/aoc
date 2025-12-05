class Solution
  def fresh?(v, ranges)
    ranges.any? {|r| r.first <= v && v <= r.last }
  end

  def explode(ranges)
    ranges = ranges.sort_by {|r| r.first }
    count = 0

    while ranges.size > 0
      r0, *r = ranges
      if r.empty? || r0.last < r.first.first
        count += (r0.last - r0.first + 1)
      else
        r[0] = [r0.first, [r0.last, r[0].last].max]
      end
      ranges = r
    end

    count
  end

  def run(lines)
    i = lines.index('')
    ranges = lines[..i-1].map { |l| l.split('-').map(&:to_i) }
    values = lines[i+1..].map(&:to_i)

    yield values.select { |v| fresh?(v, ranges) }.size
    yield explode(ranges)
  end
end
