def scanmap(name, lines)
    sidx = lines.index(name) + 1
    eidx = sidx
    while lines[eidx] != "" && eidx < lines.size
        eidx += 1
    end

    lines[sidx..eidx-1].map { |x| x.split(' ').map(&:to_i) }
                       .map { |k, s, e| [s, k, e] }
end

def find(map, val)
    record = map.find { |s, k, e| s <= val && val < s+e }
    return val unless record 

    s, k, _ = *record
    return k + (val - s)
end


def find2(map, val, count)
    return [] if count <= 0
    
    record = map.find { |s, k, e| s <= val && val < s+e  }
    if record 
        s, k, e = *record
        
        r = k + (val - s)
        c = [e - (val - s), count].min
        return [[r, c]] + find2(map, val+c, count-c)
    end
        
    record = map.find { |s, k, e| s <= val+count && val+count < s+e  }
    if record 
        s, k, e = *record
        r = val
        c = (s-1) - val
        return [[r, c]] + find2(map, s, count-c)
    end

    return [[val, count]]
end

lines = ARGF.each_line.map(&:chomp)
seeds = lines.find { |l| l =~ /^seeds:/ }[/^seeds:(.*)$/, 1]
             .split(' ')
             .map(&:to_i)

maps = [
    'seed-to-soil map:', 
    'soil-to-fertilizer map:',
    'fertilizer-to-water map:',
    'water-to-light map:',
    'light-to-temperature map:',
    'temperature-to-humidity map:',
    'humidity-to-location map:'].map{ |k| scanmap(k, lines) }

puts seeds.map { |s| maps.inject(s) { |s, m| find(m, s) } }.min
puts maps.inject(seeds.each_slice(2).to_a) { |ranges, map| ranges.inject([]) { |acc, r| acc + find2(map, *r) } }
         .map(&:first)
         .min
