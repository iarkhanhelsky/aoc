class Solution
    LEGEND = {
        '|' => [[1, 0], [-1, 0]], # is a vertical pipe connecting north and south.
        '-' => [[0, 1], [0, -1]], # is a horizontal pipe connecting east and west.
        'L' => [[0, 1], [-1, 0]], # is a 90-degree bend connecting north and east.
        'J' => [[0, -1], [-1, 0]], # is a 90-degree bend connecting north and west.
        '7' => [[1, 0], [0, -1]], # is a 90-degree bend connecting south and west.
        'F' => [[1, 0], [0, 1]], # is a 90-degree bend connecting south and east.
        '.' => [], # is ground; there is no pipe in this tile.
    }
 
    START = 'S' # is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
 
    def decode(map, start)
        map = map.size.times.map do |i|
            map[i].size.times.map do |j|
                c = map[i][j]
                LEGEND[c]
            end
        end

        i0, j0 = *start
        map[i0][j0] = []
        
        (-1..1).map do |i|
            (-1..1).map do |j|
                k = i0 + i
                p = j0 + j

                next if !(k >= 0 && k < map.size && p >= 0 && p < map[i].size)
                next unless map[k][p].find { |x, y| k + x == i0 && p + y == j0 }

                map[i0][j0] << [k - i0, p - j0]
            end
        end

        map
    end

    def score(map, start)
        i0, j0 = *start

        scores = map.map { |r| r.map { nil } }
        scores[i0][j0] = 0

        visited = []
        frontier = [[i0, j0]]
        while !frontier.empty?        
            i, j = frontier.pop

            visited << [i, j]
            map[i][j].each do |x, y|
                next if i + x == i0 && j + y == j0

                s = scores[i + x][j + y]
                s0 = scores[i][j] + 1
                if s.nil? || s > s0
                    scores[i + x][j + y] = s0
                    frontier << [i + x, j + y]
                end
            end
        end

        scores
    end

    def start(map)
        i0 = map.index { |r| r.any? { |c| c == 'S' } }
        j0 = map[i0].index { |c| c == 'S' }

        [i0, j0]
    end

    def mark(scores, sketch)
        map = scores.size.times.map do |i|
            scores[i].size.times.map { |j| scores[i][j] ? sketch[i][j] : '.' }
        end
        
        unknown = []
        map.size.times do |i|
            map[i].size.times do |j|
                fill(map, i, j, '0') if (i == 0 || i == map.size - 1)
                fill(map, i, j, '0') if (j == 0 || j == map[i].size - 1)    
                
                unknown << [i, j] if map[i][j] == '.'
            end
        end
        
        while !unknown.empty?
            i, j = *unknown.shift
            next if map[i][j] != '.'

            c = 0
            prev = nil
            r = map[i][0..j]
            while !r.empty?
                x = r.pop
                break if x == '0'
                next if x == '-'

                if (x == 'L' && prev == 'J') or (x == 'F' && prev == '7')
                    c = c + 2
                elsif (x == '|' || (x == 'L' && prev == '7') || (x == 'F' && prev == 'J'))
                    c = c + 1
                end

                prev = x
            end

            d = 0
            prev = nil
            r = map[0..i].map { |x| x[j] }
            while !r.empty?
                x = r.pop
                break if x == '0'
                next if x == '|'

                if (x == '7' && prev == 'J') or (x == 'F' && prev == 'L')
                    d = d + 2
                elsif (x == '-' || (x == '7' && prev == 'L') || (x == 'F' && prev == 'J'))
                    d = d + 1
                end

                prev = x
            end
            # puts "#{i}, #{j}: #{c}, #{d}: #{map[i].join}"
            fill(map, i, j, '0') if c.even? && d.even?
        end
        
        # map.each { |l| puts l.join }

        map
    end

    def fill(map, i0, j0, ch)
        return if map[i0][j0] != '.'

        queue = [[i0, j0]]

        while !queue.empty?
            i0, j0 = *queue.pop
            map[i0][j0] = ch
            (-1..1).map do |i|
                (-1..1).map do |j|
                    k = i0 + i
                    p = j0 + j

                    next if !(k >= 0 && k < map.size && p >= 0 && p < map[i].size)
                    next if map[k][p] != '.'

                    queue << [k, p]
                end
            end
        end
    end

    def run(lines)
        sketch = lines.map { |l| l.chars }
        start = start(sketch)
        map = decode(sketch, start)
        
        scores = score(map, start)
        max = scores.flatten.compact.max
         
        return [max, mark(scores, sketch).flatten.count { |x| x == '.' }]
    end
end
