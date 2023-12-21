class Solution
    DIRECTIONS = [
        [-1, 0], [1, 0],
        [0, -1], [0, 1]
    ]
    def scan(grid, limit = 64)
        i0 = -1
        j0 = -1 

        grid.size.times do |i|
            grid[0].size.times do |j|
                if grid[i][j] == 'S'
                    i0 = i
                    j0 = j
                end
            end
        end

        score = grid.map { |r| r.map { 1/0.0 } }
        score[i0][j0] = 0
        pool = [[i0, j0]]
        while !pool.empty?
            i, j = *pool.pop
            DIRECTIONS.each do |di, dj|
                if i + di >= 0 && i + di < grid.size
                    if j + dj >= 0 && j + dj < grid[0].size
                        s = score[i][j] + 1
                        if s <= limit
                            if grid[i + di][j + dj] != '#'
                                if s < score[i + di][j + dj] 
                                    score[i + di][j + dj] = s
                                    if !pool.include?([i + di, j + dj])
                                        pool << [i + di, j + dj]
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        result = 0
        grid.size.times do |i|
            row = []
            grid[0].size.times do |j|
                if score[i][j] == 1/0.0
                    row << grid[i][j]
                else
                    if score[i][j].even? || score[i][j] == limit
                        row <<'O'
                        result = result + 1
                    else
                        row << '.'
                    end
                end
            end

            puts row.join
        end

        result
    end

    def run(lines)
        grid = lines.map(&:chars)
        scan(grid, 64)
    end
end
