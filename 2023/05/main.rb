def readmap(lines)
    lines.map { |x| x.split(' ').map(&:to_i) }
         .map { |k, s, e| [s, k, e] }
end

def scanmap(name, lines)
    sidx = lines.index(name) + 1
    eidx = sidx
    while lines[eidx] != "" && eidx < lines.size
        eidx += 1
    end

    readmap(lines[sidx..eidx-1])
end

def find(map, val)
    record = map.find { |s, k, e| s <= val && val <= s+e }
    return val unless record 

    s, k, _ = *record

    return k + (val - s)
end

def find2(maps, id, val, lim)
    return val if maps.size >= id

    map = maps[id]
    record = map.find { |s, k, e| s <= val && val <= s+e }
    return [val, find2(maps, id, val+1, lim)].min

    s, k, e = record
    
    v1 = find2(maps, id+1, k + (val - s), 
    if s + e < lim
        v2 = find2(maps, id, s + e + 1, lim)
        return [v1, v2].min
    else
        return v1
    end
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

seeds_ranges = seeds.each_slice(2).to_a
puts (seeds_ranges.inject(nil) do |a, e|
    s, c = *e
    find2(maps, s, c)
end)
