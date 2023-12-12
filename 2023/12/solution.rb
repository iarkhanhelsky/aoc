class Solution
    def arrangements(row, sum, s0 = 0)

        if sum.empty? && row[s0..].all? { |c| c == '.' || c == '?' }
            return 1 
        end

        group = sum.first || 0
        pool = [['', 0]]
        matched = 0

        while !pool.empty?
            x, c = *pool.pop
            if c == group && s0 + x.size == row.size && x.size != 0 && sum.size == 1
                matched = matched + 1 
            end

            ch = row[s0+x.size]

            variants = []
            case ch
            when '?'
                variants << '.'
                variants << '#'
            when '.', '#'
                variants <<  ch
            end

            variants.each do |ch|
                case ch
                when '.'
                    if c == group && x.end_with?('#')
                        matched = matched + arrangements(row, sum[1..], s0 + x.size + 1) 
                    end
                    pool << [x + ch, 0] if c == 0
                when '#'
                    pool << [x + ch, c + 1] if c < group
                end
            end
        end

        matched
    end

    def run(lines)
        rows = lines.map { |l| l.split(' ') }
                    .map { |row, sum| [row.chars, sum.split(',').map(&:to_i)] }

        p1 = rows.map { |row, sum| arrangements(row, sum) }
        p2 = []
                
        [
            p1.sum,
            p2.sum
        ]
    end
end
