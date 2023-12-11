class Solution
    def expand(map)
        rows = []
        map.size.times do |i|
            rows << i if map[i].all?('.')
        end

        s = 0
        rows.each { |i| map.insert(i + s, ('.' * map.first.size).chars); s = s + 1 }        

        cols = []
        map.first.size.times do |j|
            cols << j if map.all? { |r| r[j] == '.' }
        end

        s = 0
        cols.each { |j| map.each { |r| r.insert(j + s, '.') }; s = s + 1 }


        map
    end

    def scan(map)
        rows = []
        map.size.times do |i|
            rows << i if map[i].all?('.')
        end

        cols = []
        map.first.size.times do |j|
            cols << j if map.all? { |r| r[j] == '.' }
        end

        [rows, cols]
    end

    def distance(p0, p1, rows, cols, mul)
        rows = rows.select { |r| [p0.first, p1.first].min < r && r < [p0.first, p1.first].max }.size
        cols = cols.select { |c| [p0.last, p1.last].min < c && c < [p0.last, p1.last].max }.size

        dx = (p0.first - p1.first).abs - rows + rows * mul
        dy = (p0.last - p1.last).abs - cols + cols * mul

        # p "#{p0.inspect} -> #{p1.inspect}: #{dx + dy}"
        # p "#{rows} #{cols}"
        dx + dy
    end

    def run(lines)
        map = lines.map { |l| l.chars }
        rows, cols = scan(map)
        galaxies = []
        map.size.times do |i|
            map[i].size.times do |j|
                galaxies << [i, j] if map[i][j] == '#'
            end
        end

        pairs = galaxies.combination(2)

        [2, 10, 100, 1000000].map do |mul|
            pairs.map { |p0, p1| distance(p0, p1, rows, cols, mul) }.sum
        end
    end
end
