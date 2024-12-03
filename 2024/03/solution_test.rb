require 'test/unit'
require_relative './solution'


class SolutionTest < Test::Unit::TestCase
    def setup
        @solution = Solution.new
    end
  
    def test_fail
        assert_not_nil(@solution, 'solution should not be nil')
    end

    def test_parse
        assert_equal(@solution.parse("mul(2,3)"), [[2, 3]])  
        assert_equal(@solution.parse("mul(2,3)mul(10,15)"), [[2, 3], [10,15]])      

        test_input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
        assert_equal(@solution.parse(test_input), [
            [2, 4],
            [5, 5],
            [11, 8],
            [8, 5],
        ])
    end 

    def test_parse2
        test_input = @solution.sanitize("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
        assert_equal(@solution.parse(test_input), [
            [2, 4],
            [8, 5]
        ])

        test_input = @solution.sanitize("don't()don't()'?,*where()<[>!mul(345,427))~ do()")
        assert_equal(@solution.parse(test_input), [])
    end
  end
  