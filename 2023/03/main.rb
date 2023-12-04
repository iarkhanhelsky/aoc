SKIP_LIST = ('0'..'9').to_a + ['.']
def adj?(schema, i0, j0)
    (i0-1 .. i0+1).each do |i|
        (j0-1 .. j0+1).each do |j|
            next if i < 0 || i >= schema.length
            next if j < 0 || j >= schema[i].length
            
            return [i, j] unless SKIP_LIST.include?(schema[i][j])
        end
    end

    return nil
end

def collect(schema)
    values = []
    schema.each_with_index do |e, i|
        value = ''
        adj = false
        adj_map = []

        e.each_with_index do |v, j|
            case v
            when '0'..'9'
                value += v
                if a = adj?(schema, i, j)
                    adj ||= true
                    adj_map << {i: a.first, j: a.last, v: schema[a.first][a.last]}
                end
                
            else
                values << [value, adj_map.uniq] if value.size > 0 && adj
                
                value =  ''
                adj_map = []
                adj = false
            end
        end

        values << [value, adj_map.uniq] if value.size > 0 && adj
    end

    return values
end

schema = ARGF.each_line
             .map { |l| l.chomp }
             .map { |l| l.chars }

values = collect(schema)
puts values.map { |x| x.first.to_i }.sum

groups = values.inject({}) do |acc, v|
    value, part = *v
    acc.update(part.first => (acc[part.first] || []) << value.to_i)
end

puts groups.select { |k, _| k[:v] == '*' }
           .select { |_, v| v.length == 2 }
           .map { |_, v| v.inject(&:*) }
           .sum