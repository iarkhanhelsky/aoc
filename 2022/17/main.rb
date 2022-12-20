SHAPES = [
	[
		['#', '#', "#", "#"]
	],
	[
		[nil, 'x', nil],
		['x', 'x', 'x'],
		[nil, 'x', nil]
	],
	[
		['@', '@', '@'],
		[nil, nil, '@'],
		[nil, nil, '@']
	],
	[
		['!'],
		['!'],
		['!'],
		['!']
	],
	[
		['b', 'd'],
		['p', 'q']
	]
]

FIELD_WIDTH = 7
FIELD_HEIGHT = 3

def simulate(commands, moves=1000000000000)
	field = Array.new(FIELD_HEIGHT) { Array.new(FIELD_WIDTH) }
	cmdx = 0

	move = 0
	dsz = 0
	journal = []
	while move < moves
		cmdx = move(move, cmdx, commands, field)
		idx = field.index { |r| r.all? { |x| !x.nil? } }
		if !idx.nil? && idx > 1
			dsz += field.size - idx
			record = [move, dsz, field.size - idx, idx]
			if prev = journal.find { |r| r[2] == field.size - idx && r[3] == idx }
				dmoves = move - prev[0]
				iterations = (moves - move) / dmoves
				rest = (moves - move) % dmoves
				dsz += iterations * (dsz - prev[1])
				moves = move + rest
			else
				journal << record
			end
			field = field[..idx-1]
		end
		move += 1
	end

	return field.size + dsz
end

def move(move, cmdx, commands, field, j0: 2)
	# Strip empty lines
	field.shift while field.first.all?(:nil?) && field.size > FIELD_HEIGHT
	shape = SHAPES[move % SHAPES.size]
	
	i = (field.index { |r| !r.all?(&:nil?) } || field.size) - 1 - 3
	j = j0
	
	while true
		render(field, move, 0, i, j, shape)
		dj = commands[cmdx] == '<' ? -1 : 1
		cmdx = (cmdx + 1) % commands.size
		j = j + dj if fit(i, j + dj, shape, field)
		render(field, move, 'jet', i, j, shape)
		if fit(i + 1, j, shape, field)
			i = i + 1
		else
			apply(i, j, shape, field)
			return cmdx
		end
	end

	return cmdx
end

def fit(i0, j0, shape, field)
	return false if i0 >= field.size

	for i in 0..(shape.size - 1)
		for j in 0..(shape[i].size - 1)
			return false if j0 + j < 0
			return false if j0 + shape[i].size > FIELD_WIDTH

			ti = i0 - i
			tj = j0 + j
			cell = shape[i][j]
			return if ti >= 0 && !shape[i][j].nil? && !field[ti][tj].nil?
		end
	end 	

	return true
end

def apply(i0, j0, shape, field)
	di = 0
	for i in 0..(shape.size - 1)
		for j in 0..(shape[i].size - 1)
			ti = i0 - i + di
			tj = j0 + j
			if ti == -1
				field.unshift(Array.new(FIELD_WIDTH))
				ti += 1
				di += 1
			end
			field[ti][tj] = shape[i][j] if !shape[i][j].nil?
		end
	end 
end

def render(field, move, it, i0=0, j0=0, shape=[])
	return if !ENV['DEBUG']
	loi = [i0 - shape.size, 0].min

	for i in loi..(field.size-1)
		print('%5d |' % i)
		for j in 0..(FIELD_WIDTH-1)
			cell = nil

			si = i0 - i
			sj = j - j0

			cell ||= '@' if si >= 0 && si < shape.size && sj >= 0 && sj < shape[si].size && !shape[si][sj].nil?			
			cell ||= field[i][j] if i >= 0
			
			print(cell.nil? ? '.' : cell)
		end
		print('|')
		print("  move: #{move}, it: #{it}") if i == loi
		puts

	end
	puts ('%5d +' % field.size) + '-' * (FIELD_WIDTH) + '+'
end

ARGF.each_line do |l| 
	commands = l.chomp.chars
	puts "P1: #{simulate(commands, 2022)}"
	puts "P2: #{simulate(commands, 1000000000000)}"
end