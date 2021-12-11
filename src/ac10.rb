PAIRS = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
}

def open?(ch)
    PAIRS.has_key?(ch)
end

def close?(ch)
    PAIRS.has_value?(ch)
end

def matching?(x, y)
    PAIRS[x] == y
end

def score_corrupted(ch)
    case ch
    when ')' 
        return 3
    when ']' 
        return 57
    when '}' 
        return 1197
    when '>' 
        return 25137
    else
        return 0
    end
end

def score_complete(ch)
    case ch
    when ')' 
        return 1
    when ']' 
        return 2
    when '}' 
        return 3
    when '>' 
        return 4
    else
        return 0
    end
end

def check_corrupted(line)
    stack = []
    line.chars.each do |ch|
        if open?(ch)
            stack << ch
        elsif close?(ch)
            if matching?(stack.last, ch)
                stack.pop
            else
                return [nil, ch]
            end
        end
    end

    [stack, nil]
end

def score_incomplete_line(line)
    line.inject(0) { |a, e| a * 5 + score_complete(e) }
end

raise 'Fail' unless score_incomplete_line('])}>'.chars) == 294


lines = ARGF.to_a

puts lines.map { |l| score_corrupted(check_corrupted(l).last) }.inject(&:+)
x = lines.map { |l| check_corrupted(l).first }
          .select { |l| l != nil }
          .map { |l| l.reverse.map {|x| PAIRS[x] } }
          .map { |l| score_incomplete_line(l) }
          .sort

puts x[x.size / 2]