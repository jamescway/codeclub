require 'ruby-debug'
require 'test/unit'


class Node
  attr_accessor :nxt, :val
  def initialize(val)
    @val = val
    @nxt = nil
  end

  def add(num)
    @val = num
  end
end

class Rack
  def add(val)
    new_node = Node.new(val)
    return @list = new_node if @list.nil?
    return @list.nxt = new_node if @list.nxt.nil? && new_node.val > @list.val

    if new_node.val < @list.val
      new_node.nxt = @list
      return @list = new_node
    end

    prev, node = @list, @list.nxt
    while !node.nil? and val > node.val 
      prev = prev.nxt
      node = node.nxt
    end

    prev.nxt     = new_node
    new_node.nxt = node if !node.nil?
  end

  def balls(node=@list, result=[])
    return result if node.nil?
    result << node.val
    balls(node.nxt, result)
  end

  def print_list
    node = @list
    while node != nil
      print "#{node.val} -> "
      node = node.nxt
    end
    puts "x"
  end
end

class MyTest < Test::Unit::TestCase
  def test  
    rack = Rack.new
    assert_equal([], rack.balls)
    rack.add(20); rack.print_list
    assert_equal([ 20 ], rack.balls)
    rack.add(10); rack.print_list
    assert_equal([ 10, 20 ], rack.balls)
    rack.add(30); rack.print_list
    assert_equal([ 10, 20, 30 ], rack.balls)
    rack.add(-2); rack.print_list
    assert_equal([ -2, 10, 20, 30 ], rack.balls)
    rack.add(0); rack.print_list
    assert_equal([ -2, 0, 10, 20, 30 ], rack.balls)
    rack.add(25); rack.print_list
    assert_equal([ -2, 0, 10, 20, 25, 30 ], rack.balls)        
  rescue 
    puts "ERROR: " + $!
  end
end

MyTest.new("go!")