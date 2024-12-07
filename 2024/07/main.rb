require 'benchmark'
require_relative './solution'

measured = Benchmark.measure do 
  r = Solution.new.run(ARGF.each_line.map(&:chomp)) { |result| puts result }
  puts r unless r.nil?
end
puts measured