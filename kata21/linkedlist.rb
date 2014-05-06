require 'ruby-debug'
require 'test/unit'


class Node
  attr_accessor :nxt, :prev, :val
  def initialize(val, prev=nil, nxt=nil)
    @val = val
    @nxt = nxt
    @prev = prev
  end
  def value
    @val
  end
end

class LinkedList
  attr_accessor :list, :last

  def initialize
    @list = nil
  end

  def add(val)
    new_node = Node.new(val)
    if @list.nil?
      @list = new_node
      @last = new_node
    else
      new_node.prev = @last
      @last.nxt = new_node
      @last = new_node
    end
  end

  def find(node=@list, val)
    return nil if node.nil?
    return node if node.val == val
    find(node.nxt, val)
  end

  def values(node=@list, res=[])
    return res if node.nil?
    values(node.nxt, res << node.val)
    #values(node.nxt) + [node.val]
  end

  def delete(target, node=@list)
    return if node.nil?
    if node == @list && target.val == node.val  #first node
      @list = node.nxt
      return
    end

    if node.val == target.val
      node.prev.nxt = node.nxt if node.prev != nil
      return
    end
    delete(target, node.nxt)
  end
end

class MyTest < Test::Unit::TestCase
  def test
    list = LinkedList.new
    %w[aaa bbb ccc].each { |str| list.add(str) }
    puts list.values.to_s
    puts "'ccc' exists in the list? #{list.find('ccc').to_s}"
    puts "'xxx' exists in the list? #{list.find('xxx').to_s}"
  end

  def test2
    list = LinkedList.new
    assert_nil(list.find("fred"))
    list.add("fred")
    assert_equal("fred", list.find("fred").value())
    assert_nil(list.find("wilma"))
    list.add("wilma")
    assert_equal("fred",  list.find("fred").value())
    assert_equal("wilma", list.find("wilma").value())
    assert_equal(["fred", "wilma"], list.values())

    list = LinkedList.new
    list.add("fred")
    list.add("wilma")
    list.add("betty")
    list.add("barney")
    assert_equal(["fred", "wilma", "betty", "barney"], list.values())
    list.delete(list.find("wilma"))
    assert_equal(["fred", "betty", "barney"], list.values())
    list.delete(list.find("barney"))
    assert_equal(["fred", "betty"], list.values())
    list.delete(list.find("fred"))
    assert_equal(["betty"], list.values())
    list.delete(list.find("betty"))
    assert_equal([], list.values())
  end
end

MyTest.new("go!")












