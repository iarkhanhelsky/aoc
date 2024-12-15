class Solution
  DIRECTIONS = {
    '^' => [-1, 0],
    'v' => [1, 0],
    '<' => [0, -1],
    '>' => [0, 1]
  }

  def execute!(i, j, grid, moves)
    tg = Marshal.load(Marshal.dump(grid))
    while !moves.empty?
      m = moves.shift
      di, dj = *DIRECTIONS[m]

      cp = Marshal.load(Marshal.dump(tg))
      if move(i, j, di, dj, cp)
        i += di
        j += dj
        tg = cp
      end
    end

    grid.each_with_index do |r, i|
      r.each_with_index do |c, j|
        grid[i][j] = tg[i][j]
      end
    end
  end

  def move(i, j, di, dj, grid)
    c = grid[i][j]
    i0 = i + di
    j0 = j + dj
    case grid[i0][j0] 
    when '#'
      return false
    when '.'
      grid[i][j] = '.'
      grid[i0][j0] = c
    when 'O'
      # Try moving and if moved re-try move again
      return move(i0, j0, di, dj, grid) && move(i, j, di, dj, grid)
    when '[' # left
      if dj == 0 # '^'/'v'
        ri = i0
        rj = j0 + 1
        
        return move(i0, j0, di, dj, grid) && move(ri, rj, di, dj, grid) && move(i, j, di, dj, grid)
      else
        return move(i0, j0, di, dj, grid) && move(i, j, di, dj, grid)
      end
    when ']' # right
      if dj == 0 # '^'/'v'
        li = i0
        lj = j0 - 1
        
        return move(i0, j0, di, dj, grid) && move(li, lj, di, dj, grid) && move(i, j, di, dj, grid)
      else
        return move(i0, j0, di, dj, grid) && move(i, j, di, dj, grid)
      end
    end
  end

  def transform(grid)
    grid.map do |r|
      r.flat_map do |c|
        case c
        when '#'
          ['#', '#']
        when '.'
          ['.', '.']
        when 'O'
          ['[', ']']
        when '@'
          ['@', '.']
        end
      end
    end
  end

  def pprint(grid)
    puts grid.map(&:join).join("\n")
  end

  def evaluate(grid)
    sum = 0

    grid.each_with_index do |r, i|
      grid[i].each_with_index do |c, j|
        if c == 'O' || c == '['
          sum += (100 * i + j)
        end
      end
    end

    return sum
  end
  
  def run(lines)
    split = lines.index('')
    grid1 = lines[0..split].map(&:chars)
    moves = lines[split..-1].join.chars

    grid2 = transform(grid1)
    
  
    [grid1, grid2].each do |g|
      i = g.index { |r| r.include?('@') }
      j = g[i].index('@')
  
      execute!(i, j, g, moves.dup)
      yield evaluate(g)  
    end
  end
end
