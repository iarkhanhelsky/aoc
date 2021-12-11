def read
    values = gets.split(',').map(&:to_i)
    boards = []

    while line = gets
        line = line.chomp
        if line == ''
            boards << Board.new
        else
            boards.last << line.split(' ').map(&:to_i)
        end
    end

    [values, boards]
end

class Board

    attr_reader :last

    def initialize
        @values = []
    end

    def <<(row)
        @values << row
    end

    def mark(value)
        @last = value
        @values.each do |row|
            i = row.find_index(value)
            row[i] =  -1 if i
        end
    end

    def win?
        win_rows?(@values) || win_rows?(@values.transpose)
    end

    def score
        @values.flatten.select { |x| x > 0 }.inject(&:+) * @last
    end

    def to_s
        s = "v: #{@last}\n"
        s += @values.map do |row|
            row.map { |v| v.to_s.rjust(4, ' ') }.join
        end.join("\n") 

        s
    end

    private

    def win_rows?(values)
        values.any? { |row| row.all? { |x| x < 0 } } 
    end
end

def play(values, boards)
    value = nil
    board = nil
    values.each do |v|
        boards.each { |b| b.mark(v) }
        wins = boards.reject!(&:win?)
        if !wins.nil? && !wins.empty?
            puts v
            wins.each { |w| puts "#{w}\n" }
            board = wins.last
        end
    end

    puts "WIN: #{board.last}\n #{board}"
    board
end


def print_board(board)
    board.each do |row|
        puts row.map { |v| v.to_s.rjust(4, ' ') }.join
    end
end

def main
    values, boards = read
    puts play(values, boards).score
end