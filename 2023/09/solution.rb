class Solution
    def predict(values, &block)
        return 0 if values.all? { |x| x == 0 }

        d = (values.size - 1).times.map { |i| values[i+1] - values[i] }
        block.call(values, predict(d, &block))
    end

    def run(lines)
        series = lines.map { |l| l.split.map(&:to_i) }
             
        [
            series.map { |values| predict(values) { |v, p| v.last + p } }.sum,
            series.map { |values| predict(values) { |v, p| v.first - p } }.sum,
        ]
    end
end
