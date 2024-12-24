class Solution
  def gen_gate_func(line)
    x, op, y, _, res = *line.split(' ')
    fn = ->(mem) { do_eval(mem, get(mem, x), get(mem, y), op) }
    { res => fn }
  end

  def do_eval(mem, x, y, op)
    case op
    when 'AND'
      x & y
    when 'OR'
      x | y
    when 'XOR'
      x ^ y
    end
  end

  def get(mem, x)
    v = mem[x]
    if v.is_a?(Proc)
      v = v.call(mem)
      mem[x] = v
    else
      v
    end
  end

  def eval_z(mem)
    mem.keys.select { |k| k.start_with?('z') }
            .sort.reverse
            .map { |k| get(mem, k) }
            .join
            .to_i(2)
  end

  def run(lines)
    sep = lines.index('')
    inputs = lines[...sep].map {|t| t.split(':')}.inject({}) { |acc, e| acc.update(e.first => e.last.to_i) }
    gates = lines[sep+1..].inject({}) {|acc, elem| acc.update(gen_gate_func(elem)) }

    yield eval_z({}.update(inputs).update(gates))
  end
end
