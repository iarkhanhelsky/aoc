def scan(command)
    dir, value = command.split(" ")
    case dir
    when "forward"
        [value.to_i, 0]
    when "up"
        [0, value.to_i * -1]
    when "down"    
        [0, value.to_i]
    end
end

commands = ARGF.map {|v| scan(v) }

aim = 0

x = 0
d = 0

commands.each do |h, v|
    x += h
    d += h * aim

    aim += v
end
        
puts d * x