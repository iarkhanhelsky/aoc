class Solution
    REMAP = {
        "one" => "1",
        "two" => "2",
        "three" => "3",
        "four" => "4",
        "five" => "5",
        "six" => "6",
        "seven" => "7",
        "eight" => "8",
        "nine" => "9",
        "1" => "1",
        "2" => "2",
        "3" => "3",
        "4" => "4",
        "5" => "5",
        "6" => "6",
        "7" => "7",
        "8" => "8",
        "9" => "9"
    }

    def scan_1(line)
        v = line.scan(/\d/)
        [v.first, v.last].join.to_i
    end
    
    def scan_2(line)
        k, idx = REMAP.keys
                      .map { |k| [k, line.index(k)] }
                      .select { |_, idx| idx && idx >= 0 }
                      .min { |a, b| a.last <=> b.last }
        k2, idx2 = REMAP.keys
                        .map { |k| [k, line.rindex(k)] }
                        .select { |_, idx| idx && idx >= 0 }
                        .max { |a, b| a.last <=> b.last }
        
        [REMAP[k], REMAP[k2]].join.to_i
    end

    def run(lines)
        return [
            lines.map { |l| scan_1(l) }.sum,
            lines.map { |l| scan_2(l) }.sum
        ]
    end
end