require 'test/unit'
require_relative './solution'


class SolutionTest < Test::Unit::TestCase
  def setup
      @solution = Solution.new
  end

  def test_fail
      assert_not_nil(@solution, 'solution should not be nil')
  end

  def test_quad
    size = [11, 7]
    assert_equal(0, @solution.quad(0, 0, size))
    assert_equal(0, @solution.quad(4, 0, size))
    assert_equal(nil, @solution.quad(5, 0, size))
    assert_equal(0, @solution.quad(0, 0, size))
    assert_equal(0, @solution.quad(4, 0, size))
    assert_equal(nil, @solution.quad(0, 3, size))

  end
end
  