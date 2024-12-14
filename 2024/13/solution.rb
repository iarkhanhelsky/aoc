class Solution
  def dist(p)
    (p.first**2 + p.last**2)*0.5
  end

  def count_coins(a, b, t)
    dxa, dya = *a
    dxb, dyb = *b
    x0, y0   = *t
    ra = (y0*dxb - x0*dyb)/(dya*dxb - dxa*dyb)
    rb = x0/dxb - ra*dxa/dxb

    if ra*dxa+rb*dxb == x0 && ra*dya+rb*dyb == y0
      3*ra + rb
    else
      0
    end
  end

  def run(lines)
    games = lines.each_slice(4).map do |a, b, t, _|
      adx = a[/Button A: X\+(\d+), Y\+(\d+)/, 1].to_i
      ady = a[/Button A: X\+(\d+), Y\+(\d+)/, 2].to_i
      
      
      bdx = b[/Button B: X\+(\d+), Y\+(\d+)/, 1].to_i
      bdy = b[/Button B: X\+(\d+), Y\+(\d+)/, 2].to_i

      tx = t[/Prize: X=(\d+), Y=(\d+)/, 1].to_i
      ty = t[/Prize: X=(\d+), Y=(\d+)/, 2].to_i

      [[adx, ady], [bdx, bdy], [tx, ty]]
    end

    scale = 10000000000000

    yield games.map { |a, b, t| count_coins(a, b, t) }.inject(&:+)
    yield games.map { |a, b, t| count_coins(a, b, [t[0] + scale, t[1] + scale]) }.inject(&:+)
  end
end
