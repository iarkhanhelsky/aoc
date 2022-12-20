def solve(line)
	chars = line.chars
	i = 0 
	while chars[i..(i + 13)].uniq.size != 14
		i = i + 1
	end

	return i + 14
end

ARGF.each_line do |line|
	puts solve(line.chomp)
end