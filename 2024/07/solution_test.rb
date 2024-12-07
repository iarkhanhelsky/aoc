require 'test/unit'
require_relative './solution'


class SolutionTest < Test::Unit::TestCase
    def setup
        @solution = Solution.new
    end
  
    def test_valid_contcat
        assert_equal(486, Solution::PART2.last.call(48, 6))
        assert_true(@solution.valid?(7290, [6, 8, 6, 15], operators: Solution::PART2))
    end
  end
  