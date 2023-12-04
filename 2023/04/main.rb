def score(card, cards)
    id, wins, nums, factor = *card
    score = (wins & nums).size
    cards[(id)..(id+score-1)].each { |x| x[3] += factor }
end

cards = ARGF.each_line
            .map(&:chomp)
            .map { |l| l.match(/Card\s+(\d+): (.*)$/) { |m| [m[1], m[2]] } }
            .map { |id, values| [id.to_i] + values.split('|') }
            .map { |id, win, nums| [id, win.split(' '), nums.split(' ')] }

puts cards.map { |_, win, nums| win & nums }
          .map { |c| c.size }
          .select { |v| v > 0 }
          .map { |v| 2 ** (v - 1) }
          .sum

cards = cards.map { |c| c + [1] }
cards.each do |c| 
    score(c, cards)
end
puts cards.map { |x| x[3] }.sum