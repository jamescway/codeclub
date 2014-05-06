require 'test/unit'
extend Test::Unit::Assertions
#http://sheelkapur.com/?p=52


class Node
	attr_accessor :val, :left, :right

  def initialize(v=nil)
    self.val = v
  end
end

class BST
  @root

  def initialize()
    @root = nil
  end

  def insert(num)
    if @root == nil
      puts "root null"
      @root = Node.new(num)
      return @root
    end

    puts "insert val: " + num.to_s

    if num > @root.val
      puts "here root right"
      @root.right = insert_leaf(@root.right, num)
    else
      puts "here root left"
      @root.left  = insert_leaf(@root.left, num)
    end
    @root
  end

  def insert_leaf(node, num)
    if node == nil
      puts "create leaf (#{num.to_s})"
      node = Node.new(num)
      return node
    end

    puts "insert_leaf: #{num}"

    if num > node.val
      puts "here leaf right"
      node.right = insert_leaf(node.right, num)
    else
      puts "here leaf left"
      node.left  = insert_leaf(node.left, num)
    end
    node
  end


  def print(node)
    if node == nil || node.val == nil
      return
    end
    puts "val:" + node.val.to_s
    print(node.left)
    print(node.right)
  end

  def find(node, num)
    if node == nil
      return
    end
    puts "current node:" + node.val.to_s

    if num < node.val
      return find(node.left, num)
    elsif num > node.val
      return find(node.right, num)
    elsif node.val == num
      return node
    end

    #need to test for case where num is NOT found and make that
    #return -1 or whatever

  end

end

#-------------------------------------------------

  #     5
  #    / \
  #   2   6
  #  / \
  # 1   3
  #      \
  #       4
  #treeify([5,2,6,1,3,4])

def chop(int, array)
  array = [5,2,6,1,3,4]

  bst = BST.new()

  shuffled_array = array#.shuffle

  root = nil

  shuffled_array.each do |num|
    puts "n#{num}"
    root = bst.insert(num)
  end

  puts "-------------------"
  puts "PRINTING TREE..."
  bst.print(root)
  puts "-------------------"
  puts "FINDING NODE..."
  bst.find(root, 444)
  puts "-------------------"

end

class MyTest < Test::Unit::TestCase
  def test_chop
    assert_equal(-1, chop(3, []))
    assert_equal(-1, chop(3, [1]))
    assert_equal(0,  chop(1, [1]))
    #here1
    assert_equal(0,  chop(1, [1, 3, 5]))
    assert_equal(1,  chop(3, [1, 3, 5]))
    assert_equal(2,  chop(5, [1, 3, 5]))
    assert_equal(-1, chop(0, [1, 3, 5]))
    assert_equal(-1, chop(2, [1, 3, 5]))
    assert_equal(-1, chop(4, [1, 3, 5]))
    assert_equal(-1, chop(6, [1, 3, 5]))
    #here1
    assert_equal(0,  chop(1, [1, 3, 5, 7]))
    assert_equal(1,  chop(3, [1, 3, 5, 7]))
    assert_equal(2,  chop(5, [1, 3, 5, 7]))
    assert_equal(3,  chop(7, [1, 3, 5, 7]))
    assert_equal(-1, chop(0, [1, 3, 5, 7]))
    assert_equal(-1, chop(2, [1, 3, 5, 7]))
    assert_equal(-1, chop(4, [1, 3, 5, 7]))
    assert_equal(-1, chop(6, [1, 3, 5, 7]))
    assert_equal(-1, chop(8, [1, 3, 5, 7]))
  rescue
    puts "ERROR: " + $!
  end
  def test_basic
    dep = Dependencies.new
    dep.add_direct('A', %w{ B C } )
    dep.add_direct('B', %w{ C E } )
    dep.add_direct('C', %w{ G   } )
    dep.add_direct('D', %w{ A F } )
    dep.add_direct('E', %w{ F   } )
    dep.add_direct('F', %w{ H   } )

    assert_equal( %w{ B C E F G H },   dep.dependencies_for('A'))
    assert_equal( %w{ C E F G H },     dep.dependencies_for('B'))
    assert_equal( %w{ G },             dep.dependencies_for('C'))
    assert_equal( %w{ A B C E F G H }, dep.dependencies_for('D'))
    assert_equal( %w{ F H },           dep.dependencies_for('E'))
    assert_equal( %w{ H },             dep.dependencies_for('F'))
  end
end

puts "Executing Hassan Chop!"

MyTest.new('test_basic')










