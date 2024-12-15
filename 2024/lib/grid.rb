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

  def pprint
    puts to_s
  end

  def to_s
    grid.map(&:join).join("\n")
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
end