def decode(sequence)
    zeroes, ones = count_frequencies(sequence)

    gamma = ''
    epsilon = ''

    zeroes.zip(ones).each do |z, o|
        if z > o
            gamma += '0'
            epsilon += '1'
        else
            gamma += '1'
            epsilon += '0'
        end
    end

    [gamma.to_i(2), epsilon.to_i(2)]
end

def count_frequencies(sequence)
    zeroes = []
    ones = []
    
    sequence.each do |bin|
        bin.chomp.chars.each_with_index do |ch, i|
            zeroes[i] = 0 if zeroes[i].nil?
            ones[i] = 0 if ones[i].nil?

            zeroes[i] = zeroes[i] + 1 if ch == '0'
            ones[i] = ones[i] + 1 if ch == '1'
        end
    end

    [zeroes, ones]
end

def oxygen_rate(sequence)
    bit = 0
    while sequence.size > 1 do
        zeroes, ones = count_frequencies(sequence)
        if zeroes[bit] > ones[bit]
            sequence = sequence.select { |v| v[bit] == '0' }
        else
            sequence = sequence.select { |v| v[bit] == '1' }
        end
        bit += 1
    end

    sequence.first
end

def co2_rate(sequence)
    bit = 0
    while sequence.size > 1 do
        zeroes, ones = count_frequencies(sequence)
        if zeroes[bit] <= ones[bit]
            sequence = sequence.select { |v| v[bit] == '0' }
        else
            sequence = sequence.select { |v| v[bit] == '1' }
        end
        bit += 1
    end

    sequence.first
end

def main
    values = ARGF.to_a
    puts decode(values).inject(&:*)
    puts oxygen_rate(values).to_i(2)* co2_rate(values).to_i(2)
end