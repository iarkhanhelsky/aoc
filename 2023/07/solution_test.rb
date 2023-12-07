require 'test/unit'
require_relative './solution'


class SolutionTest < Test::Unit::TestCase
    def setup
        @solution = Solution.new
    end
  
    def test_fail
        assert_not_nil(@solution, 'solution should not be nil')
    end

    def test_rank
        assert(@solution.rank('AAAAA') == 7)
        assert(@solution.rank('AA8AA') == 6)
        assert(@solution.rank('23332') == 5)
        assert(@solution.rank('TTT98') == 4)
        assert(@solution.rank('23432') == 3)
        assert(@solution.rank('A23A4') == 2)
        assert(@solution.rank('23456') == 1)
    end

    def test_compare_cards
        assert(@solution.compare_cards('33332', '2AAAA') == (1 <=> 0))
        assert(@solution.compare_cards('77888', '77788') == (1 <=> 0))
    end

    def test_compare()
        assert(@solution.compare('33332', '2AAAA') == (1 <=> 0))
        assert(@solution.compare('77888', '77788') == (1 <=> 0))
        assert(@solution.compare('33332', '77788') == (1 <=> 0))
    end

    def test_sort()
        hands = [
            '32T3K',
            'T55J5',
            'KK677',
            'KTJJT',
            'QQQJA'
        ]

        expect = [
            '32T3K',
            'KTJJT',
            'KK677',
            'T55J5',
            'QQQJA'
        ]

        sorted = hands.sort { |a, b| @solution.compare(a, b) }
        assert(sorted == expect)
    end
  end
  