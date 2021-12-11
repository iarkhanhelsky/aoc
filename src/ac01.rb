def count_increases(values)
    increases = 0
    last = values.first
    values[1..].each do |v|
        increases += 1 if v > last
        last = v
    end

    increases
end

def sliding_window(values, size = 3)
    (0..(values.size - size)).map do |i|
        values[i..(i+size - 1)].inject(&:+)
    end
end

def main
    puts count_increases(sliding_window(ARGF.map(&:to_i)))
end