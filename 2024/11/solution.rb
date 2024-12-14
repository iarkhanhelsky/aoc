class Solution
  def initialize
    @mem = {}
  end

  def digits(s)
    Math.log10(s).floor + 1
  end

  def blink(stone, round)
    return 1 if round == 0
    return @mem[[stone, round]] if @mem.key?([stone, round])

    result = []
    case
    when stone == 0
      result << 1
    when digits(stone).even?
      m = 10**(digits(stone) / 2)
      result += stone.divmod(m)
    else
      result << stone * 2024
    end

    @mem[[stone, round]] = result.inject(0) {|a, s| a + blink(s, round - 1)}
  end

  def run(lines)
    stones = lines.first.split(' ').map(&:to_i)
    yield stones.inject(0) {|acc, s| acc + blink(s, 25) }
    yield stones.inject(0) {|acc, s| acc + blink(s, 75) }
  end
end
