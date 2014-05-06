require 'test/unit'
extend Test::Unit::Assertions

class CheckOut
  def initialize(file)
    @rules = {}
    @items_count = {}
    @total = 0
    load_rules(file)
  end

  def load_rules(rules_file)
    lines = File.open(rules_file).readlines
    3.times { lines.shift }
    lines.each do | line |
      tokens = line.split(/\s/).delete_if(&:empty?)
      sku    = tokens[0]
      price  = tokens[1].to_i
      rule   = {:num => tokens[2].to_i, :for => tokens[4].to_i}
      @rules[sku] = {:price => price, :rule => rule} 
    end
  end

  def scan(sku)
    @items_count[sku] ||= 0
    @items_count[sku] += 1

    num_needed_for_discount = @rules[sku][:rule][:num]
    discounted_price = @rules[sku][:rule][:for]

    @total += @rules[sku][:price]
    if @items_count[sku] == num_needed_for_discount
      @total -= (@rules[sku][:price] * num_needed_for_discount) - discounted_price
      @items_count[sku] = 0
    end
  end

  def total
    @total
  end
end



class TestPrice < Test::Unit::TestCase
  RULES='rules'

  def price(goods)
    co = CheckOut.new(RULES)
    goods.split(//).each { |item| co.scan(item) }
    co.total
  end

  def test_totals
    assert_equal(  0, price(""))
    assert_equal( 50, price("A"))
    assert_equal( 80, price("AB"))
    assert_equal(115, price("CDBA"))

    assert_equal(100, price("AA"))
    assert_equal(130, price("AAA"))
    assert_equal(180, price("AAAA"))
    assert_equal(230, price("AAAAA"))
    assert_equal(260, price("AAAAAA"))

    assert_equal(160, price("AAAB"))
    assert_equal(175, price("AAABB"))
    assert_equal(190, price("AAABBD"))
    assert_equal(190, price("DABABA"))
  end

  def test_incremental
    co = CheckOut.new(RULES)
    assert_equal(  0, co.total)
    co.scan("A");  assert_equal( 50, co.total)
    co.scan("B");  assert_equal( 80, co.total)
    co.scan("A");  assert_equal(130, co.total)
    co.scan("A");  assert_equal(160, co.total)
    co.scan("B");  assert_equal(175, co.total)
  end
end

TestPrice.new('tests')