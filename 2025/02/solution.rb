class Solution
  def range_check(range, &block)
    left, right = *range.map { |x| x.to_i }
    x = left

    sum = 0
    while x <= right
      sum += x if block.call(x)
      x += 1
    end

    sum
  end

  def invalid_v1?(x)
    l10 = Math.log10(x).ceil
    return false if l10.odd?
      
    t = (10 ** (l10/2))
    h = x % t
    l = x / t
      
    h == l
  end

  def invalid_v2?(x)
    x.to_s =~  /^(\d+)\1+$/
  end

  def run(lines)
    ranges = lines.flat_map { |l| l.split(',') }.map { |x| x.split('-') }
    
    [
      ->(x) { invalid_v1?(x) },
      ->(x) { invalid_v2?(x) },
    ].map do |f|
      ranges.map { |r| range_check(r, &f) }.sum
    end
  end
end
