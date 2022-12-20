def parse(line)
	line.split(',').map(&:to_i)
end

def planes(point)
	x, y, z = *point
	[
		[[x, y, z],     [x + 1, y + 1, z]],
		[[x, y + 1, z], [x + 1, y + 1, z + 1]],
		[[x + 1, y, z], [x + 1, y + 1, z + 1]],
		[[x, y, z],     [x, y + 1, z + 1]],
		[[x, y, z],     [x + 1, y, z + 1]],
		[[x, y, z + 1], [x + 1, y + 1, z + 1]],
	]
end

def restore(point, cubes, planes)
	
end

cubes = ARGF.each_line.map { |l| parse(l.chomp) }
planes = cubes.flat_map { |c| planes(c) }

# P1
puts planes.group_by { |x| x }.count { |k, v| v.count == 1}

anclaves = planes.select { |w, v| w.zip(v).map {|x, y| y - x } == [1, 1, 0] }
				 .map { |w, _| w }
				 .select { |w| !cubes.include?(w) }
				 .select { |v| planes(v).all? { |p| planes.include?(p) } }

p anclaves.size
puts (planes + anclaves.flat_map { |a| planes(a) }).group_by { |x| x }.count { |k, v| v.count == 1 }