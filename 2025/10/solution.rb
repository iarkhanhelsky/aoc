require 'set'
require 'matrix'


class Solution
  MAX = 2**64

  def parse(line)
    scheme = line[/\[(.*)\]/, 1]
    bits = scheme.length
    scheme = scheme.chars.reverse.inject(0) { |a, c|  (a << 1) + (c == '.' ? 0 : 1) }
    buttons = line.scan(/\([^)]+\)/)

    buttons = buttons.map { |b| b.scan(/\d+/).inject(0) { |a, x| a | (1 << x.to_i) } }
    joltage = line[/\{(.*)\}/, 1].scan(/\d+/).map(&:to_i)

    [bits, scheme, buttons, joltage]
  end

  def pprint(v)
    v.to_s(2).rjust(10, '0')
  end

  def clicks(bits, t, buttons)
    min_clicks = [MAX] * (1 << bits)
    min_clicks[0] = 0

    better = true
    while better
      better = false

      (1 << bits).times do |current_mask|
        next if min_clicks[current_mask] == MAX

        buttons.each do |b|        
          new_mask = current_mask ^ b
          new_cost = min_clicks[current_mask] + 1
          if new_cost < min_clicks[new_mask]
            min_clicks[new_mask] = new_cost 
            better = true
          end
        end
      end
    end

    min_clicks[t]
  end


  def joltage(buttons, joltage)
    a = joltage.size.times.map do |i|
      mask = 1 << i
      buttons.map { |b| (b & mask == 0 ? 0 : 1) }
    end

    p a
    p joltage
    0
  end

  def run(lines)
    lines = lines.map { |l| parse(l) }

    yield lines.map { |bits, scheme, buttons, _| clicks(bits, scheme, buttons) }.sum
    yield lines.map { |bits, _, buttons, joltage| joltage(buttons, joltage) }.sum
  end
end
