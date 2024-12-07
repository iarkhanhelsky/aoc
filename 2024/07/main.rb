require 'benchmark'
require_relative './solution'

result = Benchmark.measure do 
  puts Solution.new.run(ARGF.each_line.map(&:chomp))
end
puts result