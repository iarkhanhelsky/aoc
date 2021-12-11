def decode_line(patterns, value)
    # a b c d e f g
    # 0         => abcefg 
    # 1 xy      => cf
    # 2         => acdeg
    # 3         => acdfg
    # 4 xyzw    => bcdf
    # 5         => abdfg
    # 6         => abdefg
    # 7 xyz     => acf
    # 8 xyzwvuo => abcdefg
    # 9         => abcdfg


    # fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    # cg => 1 => cf            | c => c, g => f 
    # gcb => 7 => acf          | b => a
    # gfac => 4 => bcdf        | fa == bd
    # cdgabef => 8 => abcdefg  | daef => bdeg
    # 
    []
end

values = ARGF.map { |line| line.split('|').map { |v| v.split(' ') } }
puts values.flat_map { |e| e.last }
           .select { |e| e.size == 2 || e.size == 3 || e.size == 4 || e.size == 7 }
           .size

puts values.map { |v| decode_line(*v) }.inject(&:+)