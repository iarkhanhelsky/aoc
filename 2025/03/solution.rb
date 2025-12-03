class Solution
  def find_joltage(batteries, seq: 2)
    right = seq
    left = 0
    
    result = []
    while result.length < seq
      right = seq - result.length
      # Need to left at least right symbols
      sub = batteries[left..-right]
      m = sub.max
      i = sub.index(m)
      result << m
      left = left + i + 1
    end
    
    result.map(&:to_s).join.to_i
  end

  def run(lines)
    batteries = lines.reject(&:empty?).map { |l| l.chars.map(&:to_i) }
    
    [2, 12].map do |seq|
      batteries.map { |b| find_joltage(b, seq: seq) }.sum
    end
  end
end
