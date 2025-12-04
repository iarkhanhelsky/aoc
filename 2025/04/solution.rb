require_relative '../lib/grid'
require_relative '../lib/directions'

class Solution
  def it(g)
    r = g.copy
    accessible = 0

    g.length.times do |i|
      g[i].length.times do |j|
        next if g[i][j] == '.' 
        t = 0 

        Directions::ALL.each do |d|
          i0, j0 = [i, j].zip(d).map {|x, y| x + y }
          t += 1 if g.check_bounds(i0, j0) && g[i0][j0] == '@'
        end

        if t < 4
          accessible += 1 
          r[i][j] = '.'
        end
      end
    end

    [r, accessible]
  end

  def run(lines)
    g = Grid.from_lines(lines)
    
    sum = 0
    r, a = *it(g)
    yield a

    sum += a
    while a != 0
      r, a = *it(r)
      sum += a
    end

    yield sum
  end
end
