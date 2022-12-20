require 'set'

class Sim
	def initialize(sz = 2)
		@rope = Array.new(sz) { [0, 0] }
		@trace = Set.new()
	end

	def old(d)
		dx, dy = *convert(d)
		@head = [@head.first + dx, @head.last + dy]
		dx, dy = [@head.first - @tail.first, @head.last - @tail.last]
		if (dx.abs > 1 || dy.abs > 1)
			dx = dx <=> 0
			dy = dy <=> 0
			@tail = [@tail.first + dx, @tail.last + dy]
		end 
		@trace << @tail
	end

	def <<(d)
		dx, dy = *convert(d)
		@rope[0] = [@rope[0].first + dx, @rope[0].last + dy]

		for i in 0..@rope.size - 2
			h = @rope[i]
			t = @rope[i + 1]

			dx, dy = [h.first - t.first, h.last - t.last]
			if (dx.abs > 1 || dy.abs > 1)
				dx = dx <=> 0
				dy = dy <=> 0
				t = [t.first + dx, t.last + dy]
			end 

			@rope[i + 1] = t
		end

		@trace << @rope.last
	end

	def convert(d)
		case d 
		when 'R'
			[1, 0]
		when 'L'
			[-1, 0]
		when 'U'
			[0, 1]
		when 'D'
			[0, -1]	
		end
	end

	def size
		@trace.size
	end
end

sim = Sim.new(10)
seq = ARGF.each_line
    	  .map { |line| line.match(/([RLUD]) (\d+)/) { |m| [m[1], m[2].to_i] } }
    	  .flat_map { |d, t| [d] * t }
    	  .each { |d| sim << d }

puts sim.size



