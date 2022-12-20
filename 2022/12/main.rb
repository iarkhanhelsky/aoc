require 'set'

def restore_path(cameFrom, current)
	size = 0
	while cameFrom.include?(current)
		current = cameFrom[current]
		size = size + 1
	end

	return size
end

def neighbors(c, grid, w, h)
	directions = [
		[-1, 0], [1, 0], [0, -1], [0, 1]
	]

	directions.map { |i, j| [c.first + i, c.last + j] }
			  .select { |i, j| i >= 0 && i < h && j >= 0 && j < w }
			  .select { |i, j| grid[i][j].ord - grid[c.first][c.last].ord <= 1 }
end

def astar(s, e, grid, w, h)
	openSet = Set.new
	openSet << s

	cameFrom = Hash.new

	gScore = Hash.new
	gScore[s] = 0

	fScore = Hash.new
	fScore[s] = (e.first - s.first).abs + (e.last - s.last).abs

	while !openSet.empty?
		c = openSet.min { |x, y| fScore[x] <=> fScore[y] }
		return restore_path(cameFrom, c) if c == e
		
		# p [c, e, openSet, w, h]
		openSet.delete(c)
		neighbors(c, grid, w, h).each do |n|
			i, j = *n
			score = gScore[c] + 1
			if !gScore.include?(n) || score < gScore[n]
				cameFrom[n] = c
				gScore[n] = score
				fScore[n] = score + (i - e.first).abs + (j - e.last).abs
				openSet << n
			end
		end
	end

	return -1
end

grid = ARGF.each_line.map { |l| l.chomp.chars }

w = grid[0].size
h = grid.size

start = [0, 0]
finish = [0, 0]
for i in 0..h-1 do
	for j in 0..w-1 do
		if grid[i][j] == 'S'
			start = [i, j]
			grid[i][j] = 'a'
		end

		if grid[i][j] == 'E'
			finish = [i, j]
			grid[i][j] = 'z'
		end
	end
end

v = astar(start, finish, grid, w, h)
puts v

min = v
for i in 0..h-1 do
	for j in 0..w-1 do
		if grid[i][j] == 'a'
			x = astar([i, j], finish, grid, w, h)
			min = [min, x].min if x >= 0
		end
	end
end

puts min