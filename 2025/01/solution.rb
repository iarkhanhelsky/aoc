class Solution
  def exec(dial, command)
    dial, z0 = *dial 
    direction = command[0] == 'L' ? -1 : 1
    count = command[1..].to_i

    x = dial + direction * (count % 100)
    z = (count / 100)

    if x <= 0 && dial > 0
      z += 1 
    elsif x >= 100      
      z += 1
    elsif x == 0
      z += 1
    end

    [x % 100, z0 + z]
  end

  def run(commands)
    history = commands.inject([[50, 0]]) {|a, c| a << exec(a.last, c) }

    r1 = history.select {|v| v.first == 0 }.count
    r2 = history.last.last

    [r1, r2]
  end
end
