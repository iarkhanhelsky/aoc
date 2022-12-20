max = []
cur = 0
ARGF.each_line do |line|
	p max
	line = line.chomp
	if line != ''
		cur += line.to_i
	else
		if max.size < 3 || cur > max[0]
			max << cur
			max.sort!
			max = max[-3..] if max.size > 3
		end
		cur = 0
	end
end

puts max.sum