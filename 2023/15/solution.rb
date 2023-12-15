class Solution
    def hash(str)
        str.chars.map(&:ord).inject(0) { |acc, e| acc = ((acc + e) * 17) % 256 }
    end

    def run(lines)
        codes = lines.first.split(',')
        boxes = Array.new(256) { [] }
        codes.each do |c|
            label = c[/^[a-z]*/]
            box = hash(label)
            op = c.include?('-') ? '-' : '='
            fl = (c[/\d+/] || 0).to_i

            case op
            when '-'
                boxes[box] = boxes[box].map { |e| e.first == label ? nil : e }.compact
            when '='

                pos = boxes[box].index { |e| e.first == label }
                if pos
                    boxes[box][pos] = [label, fl]
                else
                    boxes[box] << [label, fl]
                end
            end
        end

        values = boxes.map.with_index do |box, id|
            box.map.with_index do |l, slot|
                l.last * (id + 1) * (slot + 1)
            end
        end



        [
            codes.map { |c| hash(c) }.sum,
            values.flatten.sum
        ]
    end
end
