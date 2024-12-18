require_relative '../lib/grid'

class Solution
  def run(lines)
    h = 70
    w = 70
    sz = 1024
    if lines[0].match(/^sz:/)
      lines[0][3..]
      h, w,sz = *(lines[0][3..].split(',').map(&:to_i))
      
      lines = lines[1..]
    end
    
    grid = Grid.new(h+1) { Array.new(w+1) { '.' } }

    cooridnates = lines.map {|l| l.split(',').map(&:to_i) }
    cooridnates[0..sz-1].each { |i, j| grid[j][i] = '#' }
    
    yield grid.search([0, 0], [h, w], pass: ->(grid, i, j) { grid[i][j] == '.' })

    cooridnates[sz..].each do |i, j|
      grid[j][i] = '#'
      if !grid.search([0, 0], [h, w], pass: ->(grid, i, j) { grid[i][j] == '.' })
        yield [i,j].join(',')
        break
      end
    end
  end
end
