class Solution
    def index(update)
      update.each_with_index
            .inject({}) { |acc, elem| acc.update(elem.first => elem.last) }
    end

    def valid?(update, rules)
      index = index(update)
      update.all? { |p| !rules.key?(p) || rules[p].all? { |p0| !index.key?(p0) || index[p] < index[p0] } }
    end

    def fix(update, rules)
      update.sort do |x, y|
        if (rules[x] || []).include?(y) # x < y
          -1 
        elsif (rules[y] || []).include?(x) # y < x
          1
        else
          0
        end
      end
    end

    def run(lines)
        rules = lines.select{ |l| l.include?('|') }
                     .map { |xy| xy.split('|').map(&:to_i) }
                     .inject({}) { |acc, elem|  acc.update(elem.first => (acc[elem.first] || []) << elem.last) }

        updates = lines.select { |l| l.include?(',') }
                       .map { |l| l.split(',').map(&:to_i) }

        valid = updates.select { |u| valid?(u, rules) }
        invalid = updates.select { |u| !valid?(u, rules) }

        [valid, invalid.map {|u| fix(u, rules) }].map do |update|
          update.map { |r| r[(r.size / 2).to_i] }.sum
        end
    end
end
