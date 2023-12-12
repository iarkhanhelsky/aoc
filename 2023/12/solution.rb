class Solution
    def stat(row)
        r = row.scan(/[.]+|[#]+/)
        r.map { |x| x.start_with?('.') ? nil : x.size }.compact
    end

    def possible?(sum, stat)
        return false if stat.size > sum.size
        stat.each_with_index do |x, i|
            next if x == sum[i]

            return false if sum[i] == nil || x > sum[i]
        end

        true
    end

    def arrangements(row, sum)
        pool = ['']
        matched = []

        arrangements = 0
        while !pool.empty?
            x = pool.pop
            
            if !x.end_with?('?')
                if x.size == row.size 
                    matched << x if stat(x) == sum
                else
                    pool << x + row[x.size]
                end
            else
                prefix = x[..-2]
                variants = [prefix + '.', prefix + '#']
                
                variants.select { |r| possible?(sum, stat(r)) }
                        .each { |r| pool << r }
            end
        end

        matched.size
    end

    def run(lines)
        rows = lines.map { |l| l.split(' ') }
                    .map { |row, sum| [row.chars, sum.split(',').map(&:to_i)] }
        
        rows.map { |row, sum| arrangements(row, sum) }.sum
    end
end
