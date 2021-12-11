fish = Array.new(9, 0)
gets.split(',').map(&:to_i).each do |x|
    fish[x] += 1 
end

(0..255).each do  |d|
    next_gen = fish[0]
    (1..(fish.length - 1)).each do |i|
        fish[i - 1] = fish[i]
        fish[i] = 0
    end
    fish[6] += next_gen
    fish[8] += next_gen

    puts "#{d + 1} : #{fish.inspect}"
end

puts fish.inject(&:+)