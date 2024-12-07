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

    def run(lines)
        
        grid = lines.map { |l| l.chars }
        i = grid.index { |l| l.include?(START) }
        j = grid[i].index(START)
        grid[i][j] = '.' # erase

        patrool(grid, i, j, -1, 0)
    end
end
