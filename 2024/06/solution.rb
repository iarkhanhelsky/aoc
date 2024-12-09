require 'set'

class Solution
    START = '^'

    def check_bounds(grid, i, j)
        return i >= 0 && j >= 0 && i < grid.size && j < grid[0].size
    end

    def print(grid)
      puts grid.map { |x| x.join }.join("\n")
    end

    def patrool(grid, i, j, di, dj)
      visited = Set.new

      while check_bounds(grid, i + di, j + dj)
        visited << [i, j]
        case grid[i + di][j + dj]
        when '#'
          t = di
          di = dj
          dj = -t
        when '.'
          i = i + di
          j = j + dj
        else
          raise "Unexpected #{grid[i][j]}"
        end
      end

      visited.size + 1
    end

    def patrool_loop(grid, i0, j0, di0, dj0)
      visited = []

      i = i0
      j = j0
      di = di0
      dj = dj0
      while check_bounds(grid, i + di, j + dj)
        visited << [i, j, di, dj]
        case grid[i + di][j + dj]
        when '#'
          t = di
          di = dj
          dj = -t
        when '.'
          i = i + di
          j = j + dj
        else
          raise "Unexpected #{grid[i][j]}"
        end
      end

      obstacles = Set.new()
      visited.each do |i1, j1, di1, dj1|
        i1 = i1 + di1
        j1 = j1 + dj1
        next if grid[i1][j1] == '#'
        grid[i1][j1] = '#'
        obstacles << [i1, j1] if check_loop(grid, i0, j0, di0, dj0)
        grid[i1][j1] = '.'
      end

      return obstacles.size
    end

    def check_loop(grid, i, j, di, dj)
      visited = Set.new

      while check_bounds(grid, i + di, j + dj)
        node = [i, j, di, dj]
      
        return true if visited.include?(node)
        visited << node
        case grid[i + di][j + dj]
        when '#'
          t = di
          di = dj
          dj = -t
        when '.'
          i = i + di
          j = j + dj
        else
          raise "Unexpected #{grid[i][j]}"
        end
      end

      return false
    end

    def run(lines)
        
        grid = lines.map { |l| l.chars }
        i = grid.index { |l| l.include?(START) }
        j = grid[i].index(START)
        grid[i][j] = '.' # erase

        [
          patrool(grid, i, j, -1, 0),
          patrool_loop(grid, i, j, -1, 0)
        ]
    end
end
