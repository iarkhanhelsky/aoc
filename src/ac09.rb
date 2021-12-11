require 'set'

field = ARGF.map { |l| l.chomp.chars.map(&:to_i) }
field.insert(0, Array.new(field[0].size, 10))
field << Array.new(field[0].size, 10)

field.each do |r|
    r.insert(0, 10)
    r << 10
end

def low?(field, i, j)
    low = true

    w = field.length
    h = field[0].length
    v = field[i][j]

    return field[i - 1][j] > v && field[i + 1][j] > v && field[i][j - 1] > v && field[i][j + 1] > v
end

def find_lows(field)
    sum = 0
    points = []
    (1..(field.size - 2)).each do |i|
        (1..(field[i].size - 2)).each do |j|
            if low?(field, i, j)
                sum += (1 + field[i][j]) 
                points << [i, j]
            end
        end
    end

    [sum, points]
end

def basin(field, i, j, visited = Set.new)
    return visited if visited.include?([i, j])
    visited << [i, j]

    v = field[i][j]
    
    basin(field, i - 1, j, visited) if field[i - 1][j] > v && field[i - 1][j] < 9
    basin(field, i + 1, j, visited) if field[i + 1][j] > v && field[i + 1][j] < 9
    basin(field, i, j - 1, visited) if field[i][j - 1] > v && field[i][j - 1] < 9
    basin(field, i, j + 1, visited) if field[i][j + 1] > v && field[i][j + 1] < 9

    return visited
end

sum, points = find_lows(field)
puts sum
puts points.map {|p| basin(field, p.first, p.last).size}.sort[-3..-1].inject(1, &:*)