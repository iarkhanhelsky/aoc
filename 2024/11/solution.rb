class Solution
  def digits(s)
    Math.log10(s).floor + 1
  end

  def blink(stones)
    result = []
    stones.each do |s|
      case
      when s == 0
        result << 1
      when digits(s).even?
        m = 10**(digits(s) / 2)
        result += s.divmod(m)
      else
        result << s * 2024
      end
    end

    result
  end

  def run(lines)
    stones = lines.first.split(' ').map(&:to_i)
    yield 25.times.inject(stones) { |acc, _| blink(acc) }.size
  end
end
