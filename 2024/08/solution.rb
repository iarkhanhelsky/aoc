class Solution
    def check_bounds(grid, i, j)
        return i >= 0 && j >= 0 && i < grid.size && j < grid[0].size
    end

    def antinodes(grid, x, y, limit: 1)
      di = y[0] - x[0]
      dj = y[1] - x[1]

      antinodes = []

      c = 0
      while (c < limit || limit == 0)
        c = c + 1
        p = [y[0] + c*di, y[1] + c*dj]
        if check_bounds(grid, *p)
          antinodes << p
        else
          break # out of bounds 
        end
      end 
      
      c = 0
      while (c < limit || limit <= 0)
        c = c + 1
        p = [x[0] - c*di, x[1] - c*dj]
        if check_bounds(grid, *p)
          antinodes << p
        else
          break # out of bounds 
        end
      end  

      antinodes
    end

    def run(lines)
        grid = lines.map { |l| l.chars }
     
        locations = {}
        grid.each_with_index do |r, i|
          r.each_with_index do |c, j|
            if c != '.'
              locations[c] = (locations[c] || []) << [i, j]
            end
          end
        end

        antinodes = locations.values.flat_map do |points|
          points.combination(2).flat_map do |x, y|
            antinodes(grid, x, y)
          end
        end

        antinodes2 = locations.values.flat_map do |points|
          points.combination(2).flat_map do |x, y|
            antinodes(grid, x, y, limit: 0) + [x, y]
          end
        end

        [
          antinodes.uniq.size,
          antinodes2.uniq.size
        ]
    end
end
