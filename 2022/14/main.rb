def max(x, y)
	x < y ? y : x
end

def fill(grid, line)
	i = 0
	p0 = line[i]
	p1 = line[i + 1]
	while i + 1 < line.size do
		dx = (p1.first - p0.first) <=> 0
		dy = (p1.last - p0.last) <=> 0
		while p0 != p1 do
			grid[p0.last][p0.first] = '#'
			p0 = [p0.first + dx, p0.last + dy]
		end
		grid[p0.last][p0.first] = '#'
		i = i + 1
		p1 = line[i + 1]
	end
end

def render(grid)
	grid.map { |l| l.map { |c| c.nil? ? '.' : c }.join }.join("\n")
end

def sand(grid, start, sz)
	x, y = *start
	w, h = *sz
	trace = []

	while y < h do
		trace << [x, y]
		# puts [x, y, grid[y + 1][x], grid[y+1][x - 1], grid[y+1][x+1]].inspect
		if grid[y + 1][x].nil?
			y = y + 1
		elsif grid[y + 1][x - 1].nil?
			y = y + 1
			x = x - 1
		elsif grid[y + 1][x + 1].nil?
			y = y + 1
			x = x + 1
		else
			grid[y][x] = 'o'
			# p [x, y]
			return !(y == 0 && x == 500)
		end
	end

	while y == h && grid[y][x] == nil
		grid[y][x] = '#'
		x -= 1
	end
	#trace.each { |x, y| grid[y][x] = '~'}
	return true
end

stones = ARGF.each_line
    		 .map { |l| l.chomp.split(' -> ') }
    		 .map { |s| s.map { |p| p.split(',').map(&:to_i) } }
sz = stones.flatten(1).inject([0, 0]) { |a, xy| [max(a.first, xy.first), max(a.last, xy.last)]}

# grid = Array.new(sz.last + 1) { Array.new(sz.first + 1) }
# source = [500, 0]
# grid[source.last][source.first]= '+'
# stones.each { |l| fill(grid, l) }

# total = 0
# while sand(grid, source, sz)
# 	total += 1
# end
# puts total

grid = Array.new(sz.last + 3) { Array.new(sz.first + 1) }
source = [500, 0]
grid[source.last][source.first]= '+'
stones.each { |l| fill(grid, l) }
fill(grid, [[0, sz.last + 2], [sz.first + 1, sz.last + 2]])

total = 0
while sand(grid, source, [sz.first + 1, sz.last + 2])
	# IO.write('o.txt', render(grid))
	# sleep 0.3
	total += 1
end

puts total
puts render(grid)