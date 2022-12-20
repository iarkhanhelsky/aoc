MAP = {
	'A' => 'R',
	'B' => 'P',
	'C' => 'S',
	'X' => 'R',
	'Y' => 'P',
	'Z' => 'S'
}

SCORE = {
	'R' => 1, # Rock
	'P' => 2, # Papper
	'S' => 3, # Scissors
}

DEFEATS = {
	'R' => 'S',
	'P' => 'R',
	'S' => 'P'
}

def score(x, y)
	s = SCORE[y]
	s += 3

	if x != y
		if DEFEATS[y] == x
			s += 3
		else
			s -= 3
		end
	end

	return s
end

def parse(x, y)
	x = MAP[x]
	case y
	when 'X'
		y = DEFEATS[x]
		
	when 'Y'
		y = x
	when 'Z'
		y = DEFEATS.find { |_, v| v == x }.first
	end

	return [x, y]
end

puts ARGF.each_line.map { |x| parse(*x.chomp.split(' '))}
	               .map { |x, y| score(x, y) }
	               .inject(&:+)
