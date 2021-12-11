require 'set'
def segments(values)
    values.map do |line|
        line.split(" -> ").map { |s| s.split(',').map(&:to_i) }
    end
end

def along_axes?(line)
    vertical?(line) || horizontal?(line)
end

def vertical?(line)
    line[0][1] == line[1][1]
end

def horizontal?(line)
    line[0][0] == line[1][0]
end

def intersections(segments)
    sum = Set.new
    (0..segments.length - 1).each do |i|
        ((i + 1)..segments.length - 1).each do |j|
            sum += intersect_s(segments[i], segments[j])
        end
    end

    sum
end

def intersect_s(x, y)
    points(x).intersection(points(y))
end

def points(line)
    x0 = line[0][0]
    x1 =  line[1][0]

    y0 = line[0][1]
    y1 = line[1][1]

    dx = (x1 - x0) <=> 0
    dy = (y1 - y0) <=> 0

    x = x0
    y = y0

    r = []

    while !(x == x1 &&  y == y1)
        r << [x, y]
        x += dx
        y += dy
    end

    r << [x1, y1]
    
    r
end

p points([[9, 4], [3, 4]])
raise "Fail" if Set.new(points([[9, 4], [3, 4]])) != Set.new([[3, 4], [4, 4], [5, 4], [6, 4], [7,4], [8, 4], [9, 4]])
raise "Fail" if points([[1,1],[3,3]]) != [[1,1],[2,2],[3,3]]
p points([[9,7],[7,9]])
raise "Fail" if points([[9,7],[7,9]]) != [[9, 7],[8, 8],[7, 9]]
raise "Fail" if intersect_s([[9, 4], [3, 4]], [[3, 4], [1,4]]).size != 1

def main
    segments = segments(ARGF)
    puts intersections(segments.select { |l| along_axes?(l) }).size
    puts intersections(segments(ARGF)).size
end
