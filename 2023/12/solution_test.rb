require 'test/unit'
require_relative './solution'


class SolutionTest < Test::Unit::TestCase
    def setup
        @solution = Solution.new
    end
  
    def test_fail
        assert_not_nil(@solution, 'solution should not be nil')
    end

    def test_arrangments
        [
            ['?', [1], 1, 'single ?'],
            ['???.###', [1,1,3], 1, 'test #1'],
            ['?###????????', [3,2,1], 10, 'test #2']
            
        ].each do |row, sum, count, msg|
            puts "-- #{msg} #{sum.join(',')}"
            assert_equal(count, @solution.arrangements(row.chars, sum), msg)
        end
    end
  end
  