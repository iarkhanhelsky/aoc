grid = ARGF.each_line.map {|l| l.chomp.chars.map(&:to_i) }

sz = grid.size
map = Array.new(sz) { Array.new(sz, 0)}

max_up = Array.new(sz, -1)
max_down = Array.new(sz, -1)
	
for i in 0..sz - 1 do
	for j in 0..sz - 1 do
		if max_up[j] < grid[i][j]
			map[i][j] = 1
			max_up[j] = grid[i][j]
		end

		if max_down[j] < grid[sz - i - 1][j]
			map[sz - i - 1][j] = 1
			max_down[j] = grid[sz - i - 1][j]
		end
	end
end

max_up = Array.new(sz, -1)
max_down = Array.new(sz, -1)

for j in 0..sz - 1 do
	for i in 0..sz - 1 
		if max_up[i] < grid[i][j]
			map[i][j] = 1
			max_up[i] = grid[i][j]	
		end

		if max_down[i] < grid[i][sz - j - 1]
			map[i][sz - j - 1] = 1
			max_down[i] = grid[i][sz - j - 1]	
		end
	end
end

# grid.each { |r| puts r.join }
# map.each { |r| puts r.join }

def score(i0, j0, grid, sz)
	l = 0
	r = sz - 1
	t = 0
	b = sz - 1
	for i in 0..sz - 1 do
    	if i < i0
    		t = i if grid[i][j0] >= grid[i0][j0]
    	elsif i > i0
    		b = i if b == sz - 1 && grid[i][j0] >= grid[i0][j0]
    	end
	end

	for j in 0..sz - 1 do
		if j < j0
			l = j if grid[i0][j] >= grid[i0][j0]
		elsif j > j0
			r = j if r == sz - 1 && grid[i0][j] >= grid[i0][j0]
		end	
	end

	return (j0 - l) * (r - j0) * (i0 - t) * (b - i0)
end

puts map.inject(0) { |a, r| a + r.inject(&:+) }

puts score(3, 2, grid, sz)
puts score(1, 2, grid, sz)

best = 0
for i in 0..sz - 1 do
	for j in 0..sz - 1 do
		s = score(i, j, grid, sz)
		best = s if s > best
	end
end

puts best