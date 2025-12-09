require 'benchmark'
require_relative './solution'

measured = Benchmark.measure do 
  printed = false
  r = Solution.new.run(ARGF.each_line.map(&:chomp)) { |result| puts result; printed = true }
  puts r unless (r.nil? || printed)
end
puts measured