class Solution
    def energize(grid, p0, v0)
        energized = grid.map { |r| r.map { [] } }
        
        pool = [{p: p0, v: v0}]
        
        while !pool.empty?
            n = pool.pop
            i0, j0 = *n[:p]
            di, dj = *n[:v]
            i1 = i0 + di
            j1 = j0 + dj

            next if j0 >= 0 && j0 < grid[0].size && i0 >= 0 && i0 < grid.size && energized[i0][j0].include?([di, dj])
            energized[i0][j0] << [di, dj] if j0 >= 0 && j0 < grid[0].size && i0 >= 0 && i0 < grid.size
            
            next if i1 < 0 || i1 >= grid.size
            next if j1 < 0 || j1 >= grid[0].size

            case grid[i1][j1]
            when '.'
                pool << { p: [i1, j1], v: n[:v] }
            when '|'
                if di == 0
                    v1 = [-1, 0]
                    pool << { p: [i1, j1], v: v1 }
                    v2 = [1, 0]
                    pool << { p: [i1, j1], v: v2 }
                else
                    pool << { p: [i1, j1], v: n[:v] }
                end
            when '-'
                if di == 0
                    pool << { p: [i1, j1], v: n[:v] }
                else
                    v1 = [0, -1]
                    pool << { p: [i1, j1], v: v1 }
                    v2 = [0, 1]
                    pool << { p: [i1, j1], v: v2 }
                end
            when '/'
                # [0, 1] -> [-1, 0]
                # [0, -1] -> [1, 0]
                v1 = [dj * -1, di * -1]
                pool << { p: [i1, j1], v: v1 }
            when '\\'
                # [0, 1] -> [1, 0]
                # [0, -1] -> [-1, 0]
                v1 = [dj, di]
                pool << { p: [i1, j1], v: v1 }
            end
        end

        energized
    end

    def genchar(grid, energized, i, j)
        x = energized[i][j]
        if grid[i][j] != '.'
            grid[i][j]
        elsif x.size == 0
            '.'
        elsif x.size == 1
           {[0, 1] => '>', [0, -1] => '<', [1, 0] => 'v', [-1, 0] => '^' }[x.first]
        else
            x.size
        end
    end

    def energize2(grid)
        pool = []
        grid.size.times do |i|
            pool << { p: [i, -1], v:[0, 1] }
            pool << { p: [i, grid[i].size], v:[0, -1] }
        end

        grid[0].size.times do |j|
            pool << { p: [-1, j], v:[1, 0] }
            pool << { p: [grid.size, j], v:[-1, 0] }
        end

        pool = pool.uniq

        pool.map { |r| energize(grid, r[:p], r[:v]) }
    end

    def pretty_print(grid, energized)
        grid.size.times do |i|
            puts grid[0].size.times.map { |j| genchar(grid, energized, i, j) }.join
        end
    end

    def run(lines)
        grid = lines.map(&:chars)
        [
            energize(grid, [0, -1], [0, 1]).map { |r| r.count { |x| !x.empty? } }.sum,
            energize2(grid).map { |e| e.map { |r| r.count { |x| !x.empty? } }.sum }.max,
        ]
    end
end
