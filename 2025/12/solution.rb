class Solution
  def run(lines)
    tasks = lines.select { |l| l =~ /^\d+x\d+/ }
                 .map { |l| l.split(':') }
                 .map { |a, f| [a.split('x').map(&:to_i), f.split(' ').map(&:to_i)] }

    lines.each_slice(5)
         .first(5)
         .map { |s| s[1..3] }

    yield tasks.select { |a, t| a.inject(&:*) >= t.sum * 9 }.size
  end
end
