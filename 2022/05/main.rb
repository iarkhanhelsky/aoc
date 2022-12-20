def parse_stack_level(line, stacks)
	i = 0
	row = []
	while i = line.index('[', i)
		c = i / 4
		v = line[i+1]
		row[c] = v

		i += 1
	end

	row.each.with_index.select {|v, _| v}.each do |v, i| 
		stacks[i] = [] unless stacks[i]
		stacks[i] << v
	end
	return stacks
end

def move(stacks, q, s, d)
	stacks[d] = (stacks[s][0..(q-1)]) + stacks[d]
	stacks[s] = stacks[s][q..]
end

stacks = []

commands = false
ARGF.each_line do |line|
	line = line.chomp
	parse_stack_level(line, stacks)

	line.match(/move (\d+) from (\d+) to (\d+)/) do |m|
		move(stacks, m[1].to_i, m[2].to_i - 1, m[3].to_i - 1)
	end
end

puts stacks.map { |r| r[0]}.join