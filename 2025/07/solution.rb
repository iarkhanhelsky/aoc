require 'set'
require_relative '../lib/grid'

class Solution
  def beam(grid, start)
    # Go until next split
    i, j = *start
    while grid.check_bounds(i, j)
      return [i, j] if grid[i][j] == '^'

      i = i + 1
    end
    
    nil
  end

  def trace(p, routes, mem = {})
    return 1 if routes[p].size == 0
    return mem[p] if mem.include?(p)
    v = routes[p].map { |v| trace(v, routes, mem) }.sum
    mem[p] = v
    v
  end

  def run(lines)
    grid = Grid.from_lines(lines)
    start = grid.location('S')

    queue = [beam(grid, start)]
    splits = {queue.first => []}
    terminal = []

    while !queue.empty?
      i, j = *queue.pop

      if grid[i][j] == '^'
        [-1, +1].each do |dj|
          i0 = i
          j0 = j + dj

          s = beam(grid, [i0, j0])
          if s
            queue << s unless splits.include?(s)  
            splits[s] = (splits[s] || []) << [i, j]
          else
            terminal << [i, j]
          end
        end
      end
    end

    yield splits.size
    yield terminal.map { |k| trace(k, splits) }.sum
  end
end
