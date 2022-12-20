def read
    data = []
    ARGF.each_line do |l|
        data << l.chomp.chars.map { |ch| ch.to_i }
    end

    data
end

def find(data)
    h = data.length
    w = data.first.length
    score = Array.new(h) { Array.new(w, 0) }
    q = [[0, 0]]
    while !q.empty?
        print_field(score)
        ij0 = q.pop
        neighbours(ij0, h, w).each do |ij|
            i, j = *ij
            i0,j0 = *ij0
            risk = data[i][j] + score[i0][j0]
            p risk
            p ij
            p q
            if score[i][j] == 0 || score[i][j] > risk
                score[i][j] = risk
                q << ij
            end
        end
    end
end

def neighbours(ij, h, w)
    i, j = *ij
    n = []
    n << [i - 1, j] if i > 0
    n << [i, j - 1] if j > 0
    n << [i + 1, j] if i + 1 < h
    n << [i, j + 1] if j + 1 < w

    n
end

def print_field(field)
    puts field.map {|x| x.join(',') }.join("\n")
end

def main
    find(read)
end