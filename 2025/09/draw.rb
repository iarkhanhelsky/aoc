require 'RMagick'

points = ARGF.each_line.map(&:chomp).map { |l| l.split(',').map(&:to_i) }
p points.size
max_x = points.max_by { |p| p.first }.first
max_y = points.max_by { |p| p.last }.last

max_x = 10**Math.log10(max_x).ceil
max_y = 10**Math.log10(max_y).ceil


img = Magick::Image.new(1000, 1000)
canvas = Magick::Draw.new

points.each_with_index do |p, i|
  x, y = *p
  # Draw line to previous point (circular)
  x0, y0 = *points[(i - 1) % points.size]
  canvas.circle(x/100, y/100, x/100-3, y/100-3)
  canvas.line(x0/100, y0/100, x/100, y/100)
end

canvas.draw(img)
img.write('tst.png')