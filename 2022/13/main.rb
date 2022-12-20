require 'json'

def compare(x, y, l = 0)
	puts ('  ' * l + "C: #{x.to_json} vs #{y.to_json}")
	return -1 if x == nil && y != nil
	return 1 if x != nil && y == nil
	return x <=> y if x.is_a?(Integer) && y.is_a?(Integer)
		
	x = [x] if x.is_a?(Integer)
	y = [y] if y.is_a?(Integer)
	
	i = 0
	while i < [x.size, y.size].max do
		x0 = x[i]
		y0 = y[i]
		r = compare(x0, y0, l = l + 1)
		puts ('  ' * (l + 1) + "R: #{r}")
		return r if r != 0
		i += 1
	end

	return x.size <=> y.size
end


packets = ARGF.each_line.select { |l| l.chomp.size > 0}
		              .map { |l| JSON.parse(l) }
		  
puts packets.each_slice(2)
		    .map { |x, y| r = compare(x, y); puts [x.to_json, y.to_json, r]; r }
		    .map.with_index { |r, i| [r, i] }
		    .select { |r, i| r <= 0 }
		    .map { |r, i| i + 1 }
		    .sum

packets2 = [
	[[2]], 
	[[6]]
] + packets

sorted = packets2.sort { |x, y| compare(x, y) }
puts (sorted.index([[2]]) + 1) * (sorted.index([[6]]) + 1)
					  