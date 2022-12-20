require 'json'

class Parser
	def initialize
		@path = "/"
		@tree = {'/' => {size: 0, path: '/', tree: {}}}
	end

	def parse_next(line)
		case line
		when /^\$ cd (.*)/
			p = Regexp.last_match[1]
			if File.absolute_path?(p)
				@path = p
			else
				@path = File.expand_path(File.join(@path, p))
			end

		when "$ ls"
		when /^dir .*/
		when /^(\d+) (.*)/
			size = Regexp.last_match[1]
			add(@path, size.to_i, @tree)
		else
		end
	end

	def add(path, bytes, tree)
		return if path.empty?

		if path.start_with?('/')
			node = tree['/']
			path = path[1..]
		else
			i = path.index('/')
			
			if i
				dir = path[..(i-1)]
				path = path[(i+1)..]
			else
				dir = path
				path = ''
			end
			
			if tree.key?(dir)
				node = tree[dir]
			else
				node = {size: 0, tree: {}}
				tree[dir] = node
			end
		end

		node[:size] += bytes
		add(path, bytes, node[:tree])
	end

	def to_s
		JSON.pretty_generate(@tree)
	end

	def sum(limit=100000, tree=@tree)
		s = 0
		tree.each do |k, v|
			sz = v[:size]
			s += sz if sz <= limit
			s += sum(limit, v[:tree])
		end

		return s
	end

	def find_to_remove(limit, current=-1, tree=@tree)
		tree.map do |_, t|
			next if t[:size] < limit

			c = (current < 0 || current > t[:size]) ? t[:size] : current
			find_to_remove(limit, c, tree=t[:tree])
		end.compact.min || current
	end

	def [](key, tree=@tree)
		tree[key]
	end
end


parser = Parser.new

ARGF.each_line { |l| parser.parse_next(l.chomp) }
puts parser.sum

total_used = parser['/'][:size]
free = 70000000 - total_used
need = 30000000
to_remove = need - free
puts parser.find_to_remove(to_remove)
