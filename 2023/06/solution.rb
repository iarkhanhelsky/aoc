class Solution
    def p1(t, d)
        d0 = (t**2 - 4*d)**0.5
        t1 = (0.5 * (t - d0))
        t2 = (0.5 * (t + d0))
        
        t10 = t1.ceil
        t20 = t2.floor
        
        (t20 < t2 ? t20 : t20 - 1) - (t10 > t1 ? t10 : t10 + 1) + 1
    end

    def run(lines)
        time = lines[0].scan(/\d+/)
        dist = lines[1].scan(/\d+/)

        r1 = time.map(&:to_i).zip(dist.map(&:to_i)).map {|t, d| p1(t, d) }.inject(&:*)
        r2 = p1(time.join.to_i, dist.join.to_i)

        [r1, r2]
    end
end

Solution.new
