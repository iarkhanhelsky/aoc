def read
    points = []
    commands = []
    ARGF.each_line do |line|
        case line
        when /(\d+),(\d+)/
            m = Regexp.last_match
            points << [m[1].to_i, m[2].to_i]
        when /fold along (x|y)=(\d+)/
            m = Regexp.last_match
            v = m[2].to_i
            if m[1] == 'x'
                commands << fold_x(v)
            else
                commands << fold_y(v)
            end
        end
    end

    [points, commands]
end

def fold_y(value)
    ->(point) do
        x, y = *point
        if y > value
            dist = y - value
            [x, value - dist]
        else
            point
        end
    end 
end

def fold_x(value)
    ->(point) do
        x, y = *point
        if x > value
            dist = x - value
            [value - dist, y]
        else
            point
        end
    end 
end

def main
    points, commands = read

    # First part
    puts points.map { |p| commands[0].call(p) }.uniq.size

    # all folds
    all_folds = commands.inject(points) { |list, cmd| list.map { |p| cmd.call(p) }.uniq }
    # pretty print
    max_x = all_folds.inject(0) { |a, e| a < e.first ? e.first : a }
    max_y = all_folds.inject(0) { |a, e| a < e.last ? e.last : a }
    screen = Array.new(max_y + 1) { Array.new(max_x + 1, ' ' ) }
    all_folds.each { |p| screen[p.last][p.first] = '#' }
    puts screen.map { |x| x.join }

end