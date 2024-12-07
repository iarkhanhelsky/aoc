class Solution
    SUM = ->(x, y) { x + y }
    MUL = ->(x, y) { x * y }
    CAT = ->(x, y) { x * 10 ** (Math.log10(y).floor + 1) + y }

    def parse(line)
      result, operations = *line.split(':')
      result = result.to_i
      operations = operations.split(' ').map(&:to_i)
      [result, operations]
    end

    def valid?(result, operations, operators: nil)
        variants = operations[1..-1].inject([operations.first]) do |acc, o|
          acc.flat_map { |v| operators.map { |op| op.call(v, o) } }
             .select { |x| x <= result }
        end

        variants.include?(result)
    end

    def run(lines)
        equations = lines.map { |l| parse(l) }

        yield equations.select { |eq| valid?(*eq, operators: [SUM, MUL]) }.map(&:first).sum
        yield equations.select { |eq| valid?(*eq, operators: [SUM, MUL, CAT]) }.map(&:first).sum
    end
end
