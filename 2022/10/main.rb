class CPU
	def initialize
		@cycle = 1
		@register = 1
		@sum = 0
		@crt = Array.new(6) { Array.new(40) }
	end

	def noop
		cycle
	end

	def addx(value)
		noop
		cycle { @register += value }
	end

	def cycle
		x = (@cycle - 1) % 40
		y = (@cycle - 1) / 40
		
		if @register - 1 <= x && x <= @register + 1
			@crt[y][x] = '#'
		else
			@crt[y][x] = '.'
		end

		@cycle += 1

		yield if block_given?
		if [20, 60, 100, 140, 180, 220].include?(@cycle)
			@sum += @cycle * @register
		end


	end

	def value
		@sum
	end

	def to_s
		@crt.map { |r| r.join }.join("\n")
	end
end

cpu = CPU.new
ARGF.each_line do |l|
	case  l.chomp 
	when 'noop'
		cpu.noop
	when /addx (-?\d+)/
		value = Regexp.last_match[1].to_i
		cpu.addx(value)
	end
end


puts cpu.value
puts cpu