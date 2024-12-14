class Solution
  WIDTH = 101
  HEIGHT = 103

  def parse(l)
    l.scan(/-?[0-9]+/).map(&:to_i)
  end

  def simulate(robots, size, it)
    robots.map do |x, y, dx, dy|
      [
        (x + dx * it) % size[0],
        (y + dy * it) % size[1],
        dx, dy
      ]
    end
  end

  def quad(x, y, size)
    qx = size[0] / 2
    mx = size[0] % 2
    qy = size[1] / 2
    my = size[1] % 2

    px = nil
    if x < qx
      px = 0
    elsif x >= (qx + mx)
      px = 1
    end

    py = nil
    if y < qy
      py = 0
    elsif y >= (qy + my)
      py = 1
    end

    return nil if py.nil? || px.nil?
    
    py * 2 + px
  end

  def pprint(robots, size)
    grid = Array.new(size[1]) { |_| Array.new(size[0]) {'.'} }
    size[1].times do |i|
      size[0].times do |j|
        if !quad(j, i, size)
          grid[i][j] = '*'
        end
      end
    end
    robots.each do |x, y, dx, dy|
      v = grid[y][x]
      v = 0 if ['.', '*'].include?(v)
      v += 1
      grid[y][x] = v  
    end

    grid.map(&:join).join("\n")
  end

  def count(robots, size)
    robots.map { |x, y, _, _| quad(x, y, size) }
          .compact
          .group_by { |k| k }
          .map { |_, v| v.size }
          .inject(1, &:*)
  end

  def aggregate(robots)
    avg = robots.inject([0, 0]) { |acc, r| [acc[0] + r[0], acc[1] + r[1]] }
    avg = [avg[0]/robots.size, avg[1]/robots.size]
    sq2 = robots.inject([0, 0]) { |acc, r| [ acc[0] + (r[0] - avg[0])**2, acc[1] + (r[1] - avg[1])**2] }
    sq2 = [(sq2[0]/robots.size)**0.5, (sq2[1]/robots.size)**0.5]
    sq2
  end

  def run(lines)
    robots = lines.map{ |l| parse(l) }
    size = [WIDTH, HEIGHT]
    size = robots.shift if robots[0].size == 2
    
    yield count(simulate(robots, size, 100), size)

    it = 0
    dit = 1
    while it < 165200
      robots = simulate(robots, size, 1)
      it = it + dit
      sq2 = aggregate(robots)
      if sq2[0] < 19 && sq2[1] < 19
        puts "#{it} #{sq2[0]} #{sq2[1]}"
        IO.write(ENV['TEST_FILE'] + ".out", pprint(robots, size))
        break
      end
    end
  end
end
