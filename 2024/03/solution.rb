class Solution
    def parse(l)
        l.scan(/mul\(\d+,\d+\)/)
         .map { |e| e.scan(/\d+/).map(&:to_i) }
    end

    def sanitize(l)
      l.gsub("don't()", "\ndon't()")
       .gsub("do()", "\ndo()")
       .split("\n")
       .select { |v| !v.start_with?("don't()") }
       .join
    end

    def run(lines)
      text = lines.join
      [text, sanitize(text)].map { |t| parse(t).map {|x, y| x * y }.inject(&:+) }
    end
end
