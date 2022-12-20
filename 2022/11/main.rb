def parse(lines)
	id = lines[0].match(/Monkey (\d):/)[1]
	items = lines[1].match(/Starting items: (.*)/)[1].split(', ').map(&:to_i)
	op = lines[2].match(/Operation: new = (.*)/)[1]
	test_cond = lines[3].match(/Test: divisible by (.*)/)[1].to_i
	test_true = lines[4].match(/If true: throw to monkey (.*)/)[1].to_i
	test_false = lines[5].match(/If false: throw to monkey (.*)/)[1].to_i
	{ id: id, items: items, operation: op, total: 0,
	  test: {
		cond: test_cond, true: test_true, false: test_false
	} }
end

def turn(i, monkeys, r)
	m = monkeys[i]

	while !m[:items].empty?
		m[:total] = m[:total] + 1
		
		old = m[:items].shift
		item = eval(m[:operation]) % r

		test = (item % m[:test][:cond] == 0).to_s.to_sym
		nxt = m[:test][test]

		monkeys[nxt][:items] << item
	end
end

def round(monkeys, r)
	(0..monkeys.size - 1).each { |i| turn(i, monkeys, r) }
end

def game(monkeys, rounds, r)
	(0..rounds-1).each { |i|
		round(monkeys, r) 
	}
	monkeys
end

def print(monkeys)
	monkeys.each do |m|
		puts "Monkey #{m[:id]} inspected #{m[:total]} items: #{m[:items].join(', ')}"
	end
end

monkeys = ARGF.each_line.each_slice(7).map { |x| parse(x) }
r = monkeys.map { |m| m[:test][:cond] }.inject(1) { |a, x| a * x }

print(game(monkeys, 10000, r))
