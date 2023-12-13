require 'test/unit'
require_relative './solution'


class SolutionTest < Test::Unit::TestCase
    def setup
        @solution = Solution.new
    end
  
    def test_fail
        assert_not_nil(@solution, 'solution should not be nil')
    end

    def test_reflects
        assert_equal(0, @solution.reflects?(['.', '.', '.', '.'], 1))
        assert_equal(0, @solution.reflects?('#.##..##.'.chars, 5))
        assert_equal(1, @solution.reflects?(['.', '#', '.', '.'], 1))
        assert_equal(1, @solution.reflects?('#.'.chars, 1))
    end
  end
  