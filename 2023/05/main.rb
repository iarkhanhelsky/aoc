require_relative './solution'

puts Solution.new.run(ARGF.each_line.map(&:chomp))