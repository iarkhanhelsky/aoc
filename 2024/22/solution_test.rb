require 'test/unit'
require_relative './solution'


class SolutionTest < Test::Unit::TestCase
  def setup
      @solution = Solution.new
  end

  def test_generate_123
    generated = [123]
    10.times { generated << @solution.generate(generated.last) }
    expect = [123, 
              15887950,
              16495136,
              527345,
              704524,
              1553684,
              12683156,
              11100544,
              12249484,
              7753432,
              5908254]

    expect.zip(generated).each_with_index do |xy, i|
      assert_equal(xy.first, xy.last, "iteration \##{i}")
    end
  end

  def test_generate_2000
    assert_equal(8685429, @solution.rounds(1, 2000))
    assert_equal(4700978, @solution.rounds(10, 2000))
    assert_equal(15273692, @solution.rounds(100, 2000))
    assert_equal(8667524, @solution.rounds(2024, 2000))
  end

  def test_mix
    assert_equal(37, @solution.mix(15, 42))
  end

  def test_prune
    assert_equal(16113920, @solution.prune(100000000))
  end
  
end
  