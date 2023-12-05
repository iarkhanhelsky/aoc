require_relative './solution'

Solution.new.run(ARGF.each_line.map(&:chomp))