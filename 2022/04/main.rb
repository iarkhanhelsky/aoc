def parse(line)
	line.split(',').map { |x| x.split('-').map(&:to_i) }
end

def include?(x, y)
	x.first <= y.first && y.last <= x.last
end

def overlap?(x, y)
	x.first <= y.first && y.first <= x.last
end

puts ARGF.each_line
    	 .map { |l| parse(l.chomp) }
    	 .select { |x, y| overlap?(x, y) || overlap?(y, x) }
    	 .size