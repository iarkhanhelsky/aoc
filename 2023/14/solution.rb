<<<<<<< HEAD
require "digest"
=======
require 'digest'
>>>>>>> 2e31021d5f4ec65ff026e7d68020f31d3e87fd63

class Solution
    def initialize()
        @cache = {}
        @hits = 0
        @asks = 0
    end

    def tilt_north(platform)
        platform[0].size.times do |j|
            os = 0
            i0 = 0
            platform.size.times do |i|    
                c = platform[i][j]
<<<<<<< HEAD
                os = os + 1 if c == "O"
                if c == "#" && i0 >= 0
                    (i0..i-1).each do |is|
                        platform[is][j] = os > 0 ? "O" : "."
=======
                os = os + 1 if c == 'O'
                if c == '#' && i0 >= 0
                    (i0..i-1).each do |is|
                        platform[is][j] = os > 0 ? 'O' : '.'
>>>>>>> 2e31021d5f4ec65ff026e7d68020f31d3e87fd63
                        os = os - 1
                    end
                    i0 = -1
                    os = 0
                end

<<<<<<< HEAD
                i0 = i if c != "#" && i0 < 0
=======
                i0 = i if c != '#' && i0 < 0
>>>>>>> 2e31021d5f4ec65ff026e7d68020f31d3e87fd63
            end

            if os > 0 && i0 >= 0
                (i0..platform.size - 1).each do |is|
<<<<<<< HEAD
                    platform[is][j] = os > 0 ? "O" : "."
=======
                    platform[is][j] = os > 0 ? 'O' : '.'
>>>>>>> 2e31021d5f4ec65ff026e7d68020f31d3e87fd63
                    os = os - 1
                end
            end
        end

        platform
    end

    def load(platform)
        sz = platform.size
        sum = 0
        platform.each_with_index do |r, i|
            r.each do |c|
<<<<<<< HEAD
                sum = sum + (sz - i) if c == "O"
=======
                sum = sum + (sz - i) if c == 'O'
>>>>>>> 2e31021d5f4ec65ff026e7d68020f31d3e87fd63
            end
        end

        sum 
    end

    def rotate(platform)
        platform.transpose.map { |r| r.reverse }
    end

    def cache_key(platform)
        Digest::SHA2.hexdigest(platform.map(&:join).join)
    end

    def run(lines)
        results = []
        platform = lines.map(&:chars)
        tilt_north(platform)
        results << load(platform)

        r = platform

        
        seq = []
        while !seq.include?(cache_key(r)) do
            key = cache_key(r)
            seq << key
            if !@cache.include?(key)                    
                r = rotate( # north
                    tilt_north(rotate( # east
                        tilt_north(rotate( # south
                            tilt_north(rotate( # west
                                tilt_north(r) # north
                )))))))
                @cache[key] = r.map { |x| x.dup }
            else
                r = @cache[key].map { |x| x.dup }
            end
        end
<<<<<<< HEAD

        seq.each.with_index do |s, i|
            puts "#{"%3d" % i}  #{s}  #{load(@cache[s])}"
=======
        puts ""
        puts ""

        seq.each.with_index do |s, i|
            puts "#{'%3d' % i}  #{s}  #{load(@cache[s])}"
>>>>>>> 2e31021d5f4ec65ff026e7d68020f31d3e87fd63
        end

        puts "---"
        idx = seq.index(cache_key(r))
        rx = (1000000000 - idx) % (seq.size - idx)
        p [idx, seq.size, rx]
        puts "---"
        results << load(@cache[seq[idx + rx -1]])
        
        return results
    end
end
