require 'set'

class Solution
  def check_bounds(grid, i, j)
    return i >= 0 && j >= 0 && i < grid.size && j < grid[0].size
  end

  def scan(grid, i, j, limit: 9, track_all: false)
    directions = [
      [-1, 0], [1, 0], [0, -1], [0, 1]
    ]

    neighbours = [[i, j]]
    visited = Set.new
    score = 0

    while !neighbours.empty?
      i0, j0 = neighbours.shift
      if grid[i0][j0] == limit
        score += 1 if !visited.include?([i0, j0])
        visited << [i0, j0] if !track_all

        next
      end

      directions.map {|di, dj| [i0 + di, j0 + dj] }
                .select { |i1, j1| check_bounds(grid, i1, j1) }
                .select { |i1, j1| grid[i0][j0] + 1 == grid[i1][j1] }
                .each { |i1, j1| neighbours << [i1, j1] }
    end
    
    score
  end

  def run(lines)
    grid = lines.map { |l| l.chars.map { |c| c == '.' ? '-100' : c }.map(&:to_i) }
    total_1 = 0
    total_2 = 0
    grid.each_with_index do |r, i|
      r.each_with_index do |c, j|
        if c == 0
          total_1 += scan(grid, i, j, track_all: false)
          total_2 += scan(grid, i, j, track_all: true)
        end
      end
    end

    yield total_1
    yield total_2
  end
end
