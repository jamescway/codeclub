require 'ruby-debug'
require 'test/unit'


class Node
  attr_accessor :nxt, :val, :card
  def initialize(val)
    @val = val
    @nxt = nil
  end

  def add(num)
    @val = num
  end
end

class Letters
  attr_accessor :list

  def initialize
    @list = nil
  end

  def add(val, card)
    new_node = Node.new(val)
    new_node.card = card

    #Base case...if empty, set and return
    return (@list = new_node) if @list.nil?

    #Base case...if smaller than first, insert at beginning, return
    if new_node.val < @list.val
      new_node.nxt = @list
      return (@list = new_node)
    end

    #Base case...if list size is 1
    if @list.nxt.nil?
      return (@list.nxt = new_node) if new_node.val > @list.val
    end

    prev = @list
    node = @list.nxt

    while !node.nil? and val > node.val 
      prev = prev.nxt
      node = node.nxt
    end

    prev.nxt     = new_node
    new_node.nxt = node if node != nil?
  end

  def load(str)
    str.gsub!(/\W/, "").downcase!
    @hash = {}
    str.each_char do |c|
      @hash[c] ||= 0
      @hash[c] += 1
    end

    @hash.each do |key, card|
      add(key.ord, card)
    end
  end

  #RECURSIVE BALLS
  def print_letters(node=@list)
    return if node.nil?
    node.card.times { print node.val.chr.to_s }
    print_letters(node.nxt)
  end

  def print_list
    node = @list
    while node != nil
      print "#{node.val.chr} #{node.val} -> "
      node = node.nxt
    end
    puts "x"
  end
end

class MyTest < Test::Unit::TestCase
  def test  
    letters = Letters.new
    letters.load("When not studying nuclear physics, Bambi likes to play beach volleyball")
    letters.print_list
    puts "------------PRINTING LETTERS-------------"
    letters.print_letters
    puts ""
  end
end

MyTest.new("go!")