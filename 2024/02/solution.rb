class Solution
    def bad?(t, sig)
        t.abs > 3 || t.abs < 1 || t * sig < 0
    end

    def safe?(x, treshold: 0)
        diffs = x[0..-2].zip(x[1..-1]).map { |t, v| t - v }
        sigc = diffs.count { |x| x > 0 }
        sig = sigc > diffs.size / 2 ? 1 : -1

        i = diffs.index { |t| bad?(t, sig) }
        return true unless i
        return false if treshold == 0
        
        a = (x[0, i] || []) + (x[i+1..-1] || [])
        b = (x[0, i + 1] || []) + (x[i+2..-1] || [])
        treshold = treshold - 1

        return safe?(a, treshold: treshold) || safe?(b, treshold: treshold)
    end

    def run(lines)
        values = lines.map{ |x| x.split(' ').map(&:to_i) }
        [0, 1].map { |t| values.count {|x| safe?(x,treshold: t) } }
    end
end

