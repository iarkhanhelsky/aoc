class Solution
  def v1(lines)
    values = lines.map { |l| l.split(' ') }
    values[0].size.times.inject do |a, i|
      *numbers, op = values.map { |r| r[i] }
      a + numbers.map(&:to_i).inject(&op.to_sym)
    end
  end

  def v2(lines)
    values = lines[..-2].map(&:chars)
    ops = lines[-1].split(' ').map(&:to_sym)
    
    numbers = []
    result = 0
    values[0].size.times do |i|
      r = values.map { |v| v[i] }
      if r.all? {|c| c == " " }
        result += numbers.inject(&ops.shift)
        numbers = []
      else
        numbers << r.join.to_i
      end
    end

    result += numbers.inject(&ops.shift)
    result
  end

  def run(lines)
    yield v1(lines)
    yield v2(lines)
  end
end
