require 'set'
require_relative 'directions'

class Grid < Array
  class << self
    def from_lines(lines)
      grid = Grid.new

      lines.each do |l| 
        r = l.chars.map do |c|
          if block_given?
            yield c
          else
            c
          end
        end

        grid << r
      end


      grid
    end

    def from_2d(array)
      grid = Grid.new
      array.each { |r| grid << r.map {|x| x } }
      grid
    end
  end

  def check_bounds(i, j)
    return i >= 0 && j >= 0 && i < self.size && j < self[0].size
  end

  def location(value)
    i = self.index {|r| r.include?(value) }
    nil if i.nil?
    j = self[i].index(value)

    return [i, j]
  end

  def pprint
    puts to_s
  end

  def to_s
    self.map(&:join).join("\n")
  end

  def copy
    Marshal.load(Marshal.dump(self))
  end

  def copy_to(other)
    self.each_with_index do |r, i|
      r.each_with_index do |c, j|
        other[i][j] = c
      end
    end
  end

  def search(start, goal, directions: Directions::ORTOGONAL, pass: ->(_grid, _i, _j) { true })
    queue = [start]
    visited = Set.new
    score = {start => 0}
    while !queue.empty?
      i0, j0 = *queue.shift
      next if visited.include?([i0, j0])
      visited << [i0, j0]

      if goal == [i0, j0]
        return score[goal] 
      end

      directions.each do |di, dj|
        i = i0 + di
        j = j0 + dj
        s = score[[i0, j0]] + 1
        if check_bounds(i, j) && (!score.key?([i, j]) || score[[i, j]] < s) && pass.call(self, i, j)
          queue << [i, j]
          score[[i, j]] = s
        end
      end
    end

    return nil
  end
end