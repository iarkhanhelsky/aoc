require 'set'

def increase(field)
    w = field.length
    h = field.first.length

    (0..(w-1)).each do |i|
        (0..(h - 1)).each do |j|
            field[i][j] += 1
        end
    end

    field
end

def flash(field)
    w = field.length
    h = field.first.length

    v = Set.new
    q = []

    (0..(w-1)).each do |i|
        (0..(h - 1)).each do |j|
            q << [i, j] if field[i][j] > 9
        end
    end

    while !q.empty?
        n = q.shift

        next if v.include?(n)
        v << n
      
        i, j = *n

        (-1..1).each do |k|
            (-1..1).each do |p|

                t = i + k
                u = j + k

                next if t == i && u == j
                next if !check_bounds(t, u, w, h)

                field[t][u] += 1
                q << [t, u] if field[t][u] > 9
            end
        end
    end

    v.size 
end

def reset(field)
    w = field.length
    h = field.first.length

    (0..(w-1)).each do |i|
        (0..(h - 1)).each do |j|
            field[i][j] = 0 if field[i][j] > 9
        end
    end

    field
end

def check_bounds(i, j, w, h)
    i >= 0 && i < w && j >= 0 && j < h
end

def field_to_s(field)
    field.map { |l| l.join }.join("\n")
end

def parse_field(lines)
    lines.map { |l| l.chars.map(&:to_i) }
end

f0 = parse_field <<~FIELD.split("\n")
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
FIELD

f1 = parse_field <<~FIELD.split("\n")
6594254334
3856965822
6375667284
7252447257
7468496589
5278635756
3287952832
7993992245
5957959665
6394862637
FIELD

raise 'FAIL' if f1 != increase(f0)


field = parse_field(ARGF.to_a.map {|l| l.chomp })
puts field_to_s(field)

sum = 0
(0..3).each do |i|
    puts "#{i}:" 
    increase(field)
    puts 'i -------------'
    puts field_to_s(field)
    sum += flash(field)
    puts 'f -------------'
    puts field_to_s(field)
    reset(field)
    puts '0 -------------'
    puts field_to_s(field)
    puts 
    puts
end

puts sum