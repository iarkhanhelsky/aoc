require 'test/unit'
require_relative './solution'


class SolutionTest < Test::Unit::TestCase
  def setup
      @solution = Solution.new
  end

  def test_fail
      assert_not_nil(@solution, 'solution should not be nil')
  end

  def test_convert
    assert_equal([[2, 5], [9, 3]], @solution.convert([9, 5], [2, 3]))
    assert_equal([[9, 5], [2, 3]], @solution.convert([2, 5], [9, 3]))

    p1 = [2, 5]
    p2 = [9, 3]
    assert_equal(@solution.area(p1, p2), @solution.area(*@solution.convert(p1, p2)))
  end

  def test_area
    assert_equal(24, @solution.area([9, 5], [2, 3]))
    assert_equal(3, @solution.area([1, 5], [1, 3]))
  end

  def test_winding_number()
    points = [
      [7,1],
      [11,1],
      [11,7],
      [9,7],
      [9,5],
      [2,5],
      [2,3],
      [7,3]
    ]

    assert_equal(0, @solution.winding_num(2, 7, points))
    assert_equal(0, @solution.winding_num(0, 0, points))

    p3, p4 = *@solution.convert([9,5], [2,3])

    v = (points.include?(p3) || @solution.winding_num(p3[0], p3[1], points) != 0) && (points.include?(p4) || @solution.winding_num(p4[0], p4[1], points) != 0)
    assert_true(v)
  end

  def test_intersects_edges?
    points = [
      [1,7],
      [9,7],
      [9,5],
      [2,5],
      [2,3],
      [9,3],
      [9,1],
      [1,1]
    ]

    assert_true(@solution.intersects_edges?([1,7], [9, 1], points))
  end
end
  