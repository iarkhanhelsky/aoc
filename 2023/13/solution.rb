class Solution
    def reflects?(row, pivot)
        s = 1
        smudges = 0
        while (pivot - s >= 0 && pivot + s - 1 < row.size)
            smudges = smudges + 1 if row[pivot - s] != row[pivot + s - 1]
            s = s + 1
        end

        smudges
    end


    def horizontal_reflections(pattern, smudges)
        cols = 0
        pattern[0].size.times.each do |j|
            cols = cols + j if pattern.sum { |r| reflects?(r, j) } == smudges
        end

        cols
    end

    def reflections(pattern, smudges)
        cols = horizontal_reflections(pattern, smudges)
        rows = horizontal_reflections(pattern.transpose, smudges)
        
        [cols, rows]
    end

    def run(lines)
        patterns = []
        pattern = []
        lines.each do |l|
            if l.empty?
                patterns << pattern 
                pattern = []
            else
                pattern << l.chars
            end
        end
        patterns << pattern

        [0, 1].map do |smudges|
            patterns.map { |p| reflections(p, smudges) }
                    .map { |c, r| c + r * 100 }
                    .sum
        end
    end
end
