class Solution
    LABELS = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
    LABELS2 = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]

    
    def boost(grouped)
        jokers = grouped.delete("J")
        if jokers
            if grouped.size > 0 
                top = grouped.max_by { |_, v| v.size }.first
                grouped[top] += jokers
            else
                grouped["J"] = jokers
            end
        end
    end
    
    def rank(hand, boost: false)
        cards = hand.chars
        grouped = cards.group_by {|c| c }

        boost(grouped) if boost

        return 7 if grouped.size == 1
        return 6 if grouped.any? {|k, v| v.size == 4 }
        return 5 if grouped.any? {|k, v| v.size == 3 } && grouped.size == 2
        return 4 if grouped.any? {|k, v| v.size == 3 }
        return 3 if grouped.select {|_, v| v.size == 2}.size == 2
        return 2 if grouped.select {|_, v| v.size == 2}.size == 1

        return 1
    end

    def compare_cards(h1, h2, boost: false)
        labels = boost ? LABELS2 : LABELS
        h1.chars.zip(h2.chars).each do |l, r|
            next if l == r

            return labels.index(l) <=> labels.index(r)
        end        
    end

    def compare(h1, h2, boost: false)
        cmp = rank(h1, boost: boost) <=> rank(h2, boost: boost)
        return cmp unless cmp == 0

        compare_cards(h1, h2, boost: boost)
    end

    def run(lines)
        hands = lines.map { |l| l.split(' ') }
                     .select {|v| v.size > 0 }
                     .map { |h, b| [h, b.to_i] }
        

        [false, true].map do |boost|
            sum = 0 

            hands.sort { |a, b| compare(a.first, b.first, boost: boost) }
                 .each_with_index { |h, i| sum += h.last * (i + 1) }
            
            sum
        end
    end
end