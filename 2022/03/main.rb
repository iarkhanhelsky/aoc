require 'set'

def priority(x)
	if 'a' <= x && x <= 'z'
		x.ord - 'a'.ord + 1
	else
		x.ord - 'A'.ord + 27
	end
end

puts ARGF.each_line
         .map { |l| l.chomp.chars }
         .map { |r| r[..(r.size / 2) - 1] & r[r.size/2..] }
         .map { |x| priority(x.first) }
         .inject(&:+)

puts ARGF.each_line
         .map { |l| l.chomp.chars }
         .each_slice(3).map { |x, y, z| (x & y & z).uniq }
         .map { |x| priority(x.first) }
         .inject(&:+)
