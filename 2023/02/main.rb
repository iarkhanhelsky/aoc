def round(line)
    line.scan(/(\d+ (blue|red|green))/)
                 .map(&:first)
                 .map { |x| x.split(" ") }
                 .map { |k, v| [v, k.to_i] }
                 .inject({}) { |a, e| a.update(e.first => e.last) }
end

def game(line)
    game = line[/^Game (\d+):/, 1].to_i
    rounds = line[line.index(":")..]
    rounds = rounds.split(";").map{ |x| round(x) }
    
    return {
        game: line[/^Game (\d+):/, 1].to_i,
        rounds: rounds,
    }
end

g = game("Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue")
raise g.inspect unless g != {game: 2, rounds: [
    {"blue" => 1, "green" => 2},
    {"green" => 3, "blue" => 4},
    {"green" => 1, "blue" => 1}
    ]}  

def possible?(game)
    game[:rounds].all? { |r| (r["red"] || 0) <= 12 && (r["green"] || 0) <= 13 && (r["blue"] || 0) <= 14 }
end

def power(game)
    mins = game[:rounds].inject({}) do |a, e|
        e.each { |k, v| a.update(k => [v, (a[k] || 0)].max) }
        a
    end

    p mins

    return mins.values.inject(&:*)
end

games = ARGF.each_line
            .map { |l| l.chomp }
            .map { |l| game(l) }
   
puts games.select { |g| possible?(g) }.map { |g| g[:game]}.sum
puts games.map { |g| power(g) }.sum