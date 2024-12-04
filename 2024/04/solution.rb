class Solution
    DIRECTIONS = (-1..1).flat_map { |i| (-1..1).map {|j| [i, j] } }.select {|i, j| [i, j] != [0, 0] }
    XDIRECTIONS = [
      [-1, -1], [1,  1],
      [-1,  1], [1, -1]
    ]

    def check_bounds(grid, i, j)
      return i >= 0 && j >= 0 && i < grid.size && j < grid[0].size
    end

    def count_xmas(grid)
      word = ['X', 'M', 'A', 'S'].freeze
      sum = 0
      grid.size.times do |i|
        grid[0].size.times do |j|
          sum += DIRECTIONS.count do |di, dj|
            word.size.times.all? { |c0| check_bounds(grid, i + c0 * di, j + c0 * dj) && grid[i + c0 * di][j + c0 * dj] == word[c0] }
          end
        end
      end

      sum
    end

    def count_x_mas(grid)
      sum = 0
      grid.size.times do |i|
        grid[0].size.times do |j|
          next if grid[i][j] != 'A'

          m = XDIRECTIONS.select { |di, dj| check_bounds(grid, i + di, j + dj) }
                         .map { |di, dj| grid[i + di][j + dj] }
          next if m.size != 4
          next if m[0] == 'M' && m[1] == 'M'
          next if m[2] == 'M' && m[3] == 'M'

          sum += 1 if m.sort == ['M', 'M', 'S', 'S']
        end
      end

      sum
    end

    def run(lines)
        grid = lines.map(&:chars)
        [count_xmas(grid), count_x_mas(grid)]
    end
end
