require 'test/unit'
require_relative './solution'


class SolutionTest < Test::Unit::TestCase
    def setup
        @solution = Solution.new
    end
  
    def test_fail
        assert_not_nil(@solution, 'solution should not be nil')
    end

    def test_safe
      assert_true(@solution.safe?([7,6,4,2,1]))
      assert_false(@solution.safe?([1,2,7,8,9]))
      assert_false(@solution.safe?([9,7,6,2,1]))
      assert_false(@solution.safe?([1,3,2,4,5]))
      assert_false(@solution.safe?([8,6,4,4,1]))
      assert_true(@solution.safe?([1,3,6,7,9]))
    end

    def test_safe_treshold
      assert_true(@solution.safe?([7,6,4,2,1], treshold: 1))
      assert_false(@solution.safe?([1,2,7,8,9], treshold: 1))
      assert_false(@solution.safe?([9,7,6,2,1], treshold: 1))
      assert_true(@solution.safe?([1,3,2,4,5], treshold: 1))
      assert_true(@solution.safe?([8,6,4,4,1], treshold: 1))
      assert_true(@solution.safe?([1,3,6,7,9], treshold: 1))
    end

    def test_safe_treshold_extra
      assert_true(@solution.safe?([1, 2, 3, 4, 5, 20], treshold: 1))
      assert_true(@solution.safe?([100, 2, 3, 4, 5, 6], treshold: 1))
      assert_true(@solution.safe?([1003, 999, 998, 997, 996], treshold: 1))      
      assert_false(@solution.safe?([1000, 2, 3, 4, 5, 20], treshold: 1))
      assert_false(@solution.safe?([100, 2, 3, 4, 5, 6000], treshold: 1))
    end

    def test_safe_extrav2
      assert_true(@solution.safe?([86, 87, 86, 84, 81], treshold: 1))
      assert_true(@solution.safe?([31, 29, 31, 34, 35, 38, 41, 42], treshold: 1))
      assert_true(@solution.safe?([29, 26, 27, 29, 31, 34], treshold: 1))
    end
end
  