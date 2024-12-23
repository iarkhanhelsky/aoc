class Solution
  def mix(x, y)
    x ^ y
  end

  def prune(x)
    x % 16777216
  end


  def generate(seed)
    x = seed
    
    y = x * 64
    x = prune(mix(x, y))

    y = x / 32
    x = prune(mix(x, y))

    y = x * 2048
    x = prune(mix(x, y))

    x
  end

  def rounds(seed, rounds)
    x = seed
    rounds.times { x = generate(x) }
    x
  end

  def trade(seeds, rounds: 2000)
    seq = seeds.map do |seed|
      r = [seed]
      rounds.times { r << generate(r.last) }
      r.map {|x| x % 10 }
    end

    stats = seq.map do |s|
      stat = {}
      diffs = s[0..-2].zip(s[1..]).map { |x, y| [y, y - x] }
      diffs.each_with_index do |e, i|
        next if i < 3
        v = e.first 
        s = diffs[(i-3)..i].map(&:last)
        (stat[s] ||= []) << v
      end

      stat
    end

    max = 0
    stats.flat_map { |e| e.keys }.uniq.each do |v|
      s = 0
      stats.each { |e| s += (e.key?(v) ? e[v].first : 0) }
      if s > max
        max = s
      end
    end
    
    max
  end

  def run(lines)
    yield lines.map { |x| rounds(x.to_i, 2000) }.sum
    yield trade(lines.map(&:to_i))
  end
end
