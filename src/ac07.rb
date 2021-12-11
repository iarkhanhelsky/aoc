crabs = gets.split(',').map(&:to_i)
max = crabs.max

positions = Array.new(max + 1, 0)
crabs.each { |c| positions[c] += 1 }

weighted = (0..max).map do |p|
             (0..max).inject(0) do |s, i|
                n = (i - p).abs
                t = (1 + n) * n / 2
                s + positions[i] * t
              end
           end

min_v = weighted.first
min_i = 0
weighted.each_with_index do |v, i|
    if v < min_v
        min_v = v
        min_i = i
    end
end

puts min_v