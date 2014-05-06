#!/usr/bin/ruby
require 'test/unit'
extend Test::Unit::Assertions


# method: chop
#  parameter(s):
#    int          - integer to find in array_of_int
#    array_of_int - array of sorted integers
#  return:  index of integer or -1 if not found
# def chop(int, array_of_int)

#   array = array_of_int
#   m = array.size/2  # rounds down returns int, writing 2.0 returns float
#   l = 0
#   r = array.size - 1

#   if(array.size <= 0)
#     return -1
#   end

#   while((r-l) > 1)

#     if(int < array[m])
#       #l = l
#       r = m
#     else
#       l = m
#       #r = r
#     end
#     m = (l+r)/2  # rounds down returns int, writing 2.0 returns float
#   end

#   if(int == array[l])
#     l
#   elsif(int == array[r])
#     r
#   else
#     -1
#   end
# end


  def chop(query, col)
    left = 0
    right = col.count - 1
    middle = col.count / 2

    #binding.pry if query == 5
    i = 0
    while right >= left do
      puts "  "
      puts "L:#{left}  R:#{right}  M:#{middle}"
      if query > col[middle]
        left = middle
        middle = (right + middle) / 2
      elsif query < col[middle]
        right = middle
        middle = (middle + left) / 2
      else
        return middle
      end

      i += 1
      return if i > 15
    end
    -1
  end






# def make_array(size)
#   array = []
#   size.times do |i|
#     array << i
#   end

#   return array
# end

class MyTest < Test::Unit::TestCase
  def test_chop
      assert_equal(-1, chop(3, []))
      assert_equal(-1, chop(3, [1]))
      assert_equal(0,  chop(1, [1]))
      #here1
      assert_equal(0,  chop(1, [1, 3, 5]))
      assert_equal(1,  chop(3, [1, 3, 5]))
      assert_equal(2,  chop(5, [1, 3, 5]))
      # assert_equal(-1, chop(0, [1, 3, 5]))
      # assert_equal(-1, chop(2, [1, 3, 5]))
      # assert_equal(-1, chop(4, [1, 3, 5]))
      # assert_equal(-1, chop(6, [1, 3, 5]))
      # #here1
      # assert_equal(0,  chop(1, [1, 3, 5, 7]))
      # assert_equal(1,  chop(3, [1, 3, 5, 7]))
      # assert_equal(2,  chop(5, [1, 3, 5, 7]))
      # assert_equal(3,  chop(7, [1, 3, 5, 7]))
      # assert_equal(-1, chop(0, [1, 3, 5, 7]))
      # assert_equal(-1, chop(2, [1, 3, 5, 7]))
      # assert_equal(-1, chop(4, [1, 3, 5, 7]))
      # assert_equal(-1, chop(6, [1, 3, 5, 7]))
      # assert_equal(-1, chop(8, [1, 3, 5, 7]))
    rescue
      puts "ERROR: " + $!
    end
end



puts "Executing Hassan Chop!"


#array = make_array(20)
#puts "Item index: " + chop(5, [1, 3, 5]).to_s

MyTest.new('test_chop')




#errors
#  1. cannot execute chop method with a global call
#        sol: needs to put function above global (main) type of call
#  2. problem with arrays and +1 -1 indexes, size does not equal last element (size-1 does)
#  3. problem visualizing algorithm, wrote down on a piece of paper, wrote how to calculate all variables
#  4. loop not working, round the conditionals were wrong
#  5. Not working correctly, need to test on a few test cases
#  6. needed to create a robust list of tests in order to have confidence
#  7. unit test not working, assert library not found
#
#
#

