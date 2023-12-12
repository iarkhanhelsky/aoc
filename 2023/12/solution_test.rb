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
            ['?', [1], 1],
            ['???.###', [1,1,3], 1],
            ['?###????????', [3,2,1], 10]
            
        ].each do |row, sum, count|
            assert_equal(count, @solution.arrangements(row.chars, sum))
        end
    end

    def test_stat
        [
            ['', []],
            ['....', []],
            ['#.#.###', [1, 1, 3]]
        ].each do |row, expect|
            assert_equal(expect, @solution.stat(row))
        end
    end

    def test_possible?
        [
            [[], [1, 1, 3], true],
            [[1], [1, 1, 3], true],
            [[2], [1, 1, 3], false],
            [[1, 1, 2], [1, 1, 3], true],
            [[1, 1], [1, 2], true],
        ].each do |stat, sum, expect|
            assert_equal(expect, @solution.possible?(sum, stat))
        end
    end
  end
  