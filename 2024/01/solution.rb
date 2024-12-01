class Solution
    def run(lines)
        values = lines.map { |x| x.split(' ').map(&:to_i) }
                      .inject([[], []]) { |acc, elem| [acc.first << elem.first, acc.last << elem.last]}
        
        left, right = *values
        counter = right.group_by { |x| x }
        
        s1 = left.sort.zip(right.sort).map { |x, y| (x - y).abs }.inject(&:+)
        s2 = left.map { |x| (counter[x] || []).length * x }.inject(&:+)

        [s1, s2]
    end
end
