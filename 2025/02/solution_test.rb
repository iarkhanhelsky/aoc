require 'test/unit'
require_relative './solution'


class SolutionTest < Test::Unit::TestCase
  def setup
      @solution = Solution.new
  end

  def test_fail
      assert_not_nil(@solution, 'solution should not be nil')
  end

  def test_range_check
    
  end
end
  