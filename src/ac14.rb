def read
    d = ARGF.to_a
    pattern = d.first.chomp.chars
    rules = d[2..-1].inject({}) do |a, e|
        e = e.chomp
        next if e.empty?
        k,v = *e.split(' -> ')
        a.update(k => v)
    end

    [pattern, rules]
end

def apply(pattern, rules)
    new_pattern = {}
    pattern.each do |k, count|
        n = rules[k]
        k1 = k[0] + n
        k2 = n + k[1]
        addsert(new_pattern, k1, count)
        addsert(new_pattern, k2, count)
    end

    pattern.clear
    pattern.update(new_pattern)

end

def addsert(map, key, value)
    map[key] = (map[key] || 0) + value
end

def scan(pattern)
    i = 0
    m = {}
    while i < pattern.length - 1
        l = pattern[i]
        r = pattern[i + 1]
        k = l + r
        addsert(m, k, 1)

        i += 1
    end

    m
end


def main
    pattern, rules = *read
    last = pattern[pattern.length - 1]
    
    [10, 40].each do |repeats|
        sequence = scan(pattern)
        repeats.times { apply(sequence, rules) }

        # Since we count only first letters of each pair. Final
        # letter never be counted.
        heatmap = {last => 1}
        sequence.each do |k, v|
            # Count only first letter of each pair. Second letter to
            # be included in next pair. 
            addsert(heatmap, k[0], v)
        end

        x = heatmap.values.sort
        puts x.last - x.first
    end
end