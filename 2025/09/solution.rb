class Solution

  def coef(p1, p2)
    x1, y1 = *p1
    x2, y2 = *p2

    a = y2 - y1
    b = x1 - x2
    c = x2*y1 - x1*y2

    [a, b, c]
  end


  def belongs?(p, seg)
    x0, y0 = *p
    p1, p2 = *seg

    x1, y1 = *p1
    x2, y2 = *p2

    x_in_range = (x1 < x0 && x0 < x2) || (x2 < x0 && x0 < x1) || (x1 == x0 && x0 == x2)
    y_in_range = (y1 < y0 && y0 < y2) || (y2 < y0 && y0 < y1) || (y1 == y0 && y0 == y2)

    x_in_range && y_in_range
  end

  def segments_intersect?(p1, p2, p3, p4)
    a1, b1, c1 = *coef(p1, p2)
    a2, b2, c2 = *coef(p3, p4)

    # Check if lines are parallel
    denominator = a1*b2 - a2*b1
    return false if denominator == 0

    # Calculate intersection point
    x = (b1*c2 - b2*c1).to_f / denominator
    y = (c1*a2 - c2*a1).to_f / denominator
    intersection = [x, y]

    # Check if intersection point is on both segments (but not at vertices)
    vertices = [p1, p2, p3, p4]
    return false if vertices.include?(intersection)

    # Check if intersection is within both segment bounds
    belongs?(intersection, [p1, p2]) && belongs?(intersection, [p3, p4])
  end

  def winding_num(point_x, point_y, polygon_vertices)
    # Ensure the polygon is closed (first vertex added to the end)
    polygon = polygon_vertices + [polygon_vertices[0]]
    winding_num = 0

    # Iterate through each edge of the polygon
    (0...polygon.length - 1).each do |i|
      x1, y1 = polygon[i]
      x2, y2 = polygon[i+1]

      # Check if the edge crosses the horizontal ray extending from the point
      if (y1 <= point_y && y2 > point_y) || (y1 > point_y && y2 <= point_y)
        # Calculate the x-coordinate of the intersection point
        # The intersection formula simplifies to avoid division by zero when y1 == y2
        intersection_x = x1 + (point_y - y1) * (x2 - x1) / (y2 - y1)

        # If the intersection is to the right of the point, count the crossing
        if intersection_x > point_x
          # Add 1 if the edge crosses upward, subtract 1 if downward
          if y1 < y2
            winding_num += 1
          else
            winding_num -= 1
          end
        end
      end
    end

    winding_num
  end

  def inside?(point_x, point_y, polygon_vertices)
    polygon_vertices.include?([point_x, point_y]) || winding_num(point_x, point_y, polygon_vertices) != 0
  end


  def intersects_edges?(p1, p2, polygon_vertices)
    # Ensure the polygon is closed (first vertex added to the end)
    polygon = polygon_vertices + [polygon_vertices[0]]

    # Iterate through each edge of the polygon
    (0...polygon.length - 1).each do |i|
      if segments_intersect?(p1, p2, polygon[i], polygon[i+1])
        return true
      end
    end

    return false
  end

  def area(x, y)
    ((x.first - y.first).abs + 1) * ((x.last - y.last).abs + 1)
  end

  def convert(p1, p2)
    dx = p2[0] - p1[0]
    dy = p2[1] - p1[1]

    [[p1[0] + dx, p1[1]], [p1[0], p1[1] + dy]]
  end

  def run(lines)
    points = lines.map { |l| l.split(',').map(&:to_i) }
    
    combinations = points.combination(2)
    yield combinations.map { |x, y| area(x, y) }.max

    areas = combinations.map do |p1, p2|
      p3, p4 = *convert(p1, p2)
      if inside?(p3[0], p3[1], points) && inside?(p4[0], p4[1], points)
          rect = [p1, p3, p2, p4]
          if !intersects_edges?(p1, p2, points) && !intersects_edges?(p3, p4, points)
            [area(p3, p4), rect.inspect]
          end
      end
    end
    
    yield areas.compact.max_by(&:first)
  end
end
