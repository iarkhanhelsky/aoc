class Solution
  def fuel(x)
    v = (x / 3.0).to_i - 2
    v < 0 ? 0 : v
  end

  def fuel_all(x)
    x0 = fuel(x)
    s = x0
    while x0 > 0
      x0 = fuel(x0)
      s += x0
    end
    s
  end

  def run(lines)
    values = lines.map(&:to_i)

    [
      values.map { |x| fuel(x) }.sum,
      values.map { |x| fuel_all(x) }.sum
    ]
  end
end
