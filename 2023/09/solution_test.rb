require 'test/unit'
require_relative './solution'


class SolutionTest < Test::Unit::TestCase
    def setup
        @solution = Solution.new
    end
  
    def test_predict
        r = @solution.predict([10,  13,  16,  21,  30,  45]) { |v, p| v.last + p }
        assert_equal(68, r)
    end

    def test_predict_back
        r = @solution.predict([10,  13,  16,  21,  30,  45]) { |v, p| v.first - p }
        assert_equal(5, r)
    end

  end
  