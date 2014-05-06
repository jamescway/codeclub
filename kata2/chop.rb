#!/usr/bin/ruby
require 'test/unit'
extend Test::Unit::Assertions


# method: chop 
#  parameter(s):
#    int          - integer to find in array_of_int
#    array_of_int - array of sorted integers
#  return:  index of integer or -1 if not found
def chop(int, array_of_int)

  array = array_of_int
  m = array.size/2  # rounds down returns int, writing 2.0 returns float
  l = 0
  r = array.size - 1
  
  if(m == 0 && array.size <= 0)
    return -1
  end
  
  while((r-l) > 1)
    puts "l: #{l}  r:#{r} - m: #{m} "
    if(int < array[m])
      l = l
      r = m      
    else
      l = m
      r = r
    end    
    m = (l+r)/2  # rounds down returns int, writing 2.0 returns float
  end
  
  res = nil
  if(int == array[l])
    res = l
  elsif(int == array[r])
    res = r
  else
    res = -1
  end
  
  puts "Item index: " + res.to_s
  return res
end

def make_array(size)
  array = []
  size.times do |i|
    array << i
  end
  # puts "#{array.to_s}"
  return array
end

def test_chop
    puts "1"
    assert_equal(-1, chop(3, []))
    puts "2"
    assert_equal(-1, chop(3, [1]))
    puts "3"
    assert_equal(0,  chop(1, [1]))
    #here1
    puts "4"
    assert_equal(0,  chop(1, [1, 3, 5]))
    puts "5"
    assert_equal(1,  chop(3, [1, 3, 5]))
    puts "6"
    assert_equal(2,  chop(5, [1, 3, 5]))
    puts "7"
    assert_equal(-1, chop(0, [1, 3, 5]))
    puts "8"
    assert_equal(-1, chop(2, [1, 3, 5]))
    puts "9"
    assert_equal(-1, chop(4, [1, 3, 5]))
    puts "10"
    assert_equal(-1, chop(6, [1, 3, 5]))
    #here1
    puts "11"
    assert_equal(0,  chop(1, [1, 3, 5, 7]))
    puts "12"
    assert_equal(1,  chop(3, [1, 3, 5, 7]))
    puts "13"
    assert_equal(2,  chop(5, [1, 3, 5, 7]))
    puts "14"
    assert_equal(3,  chop(7, [1, 3, 5, 7]))
    puts "15"
    assert_equal(-1, chop(0, [1, 3, 5, 7]))
    puts "16"
    assert_equal(-1, chop(2, [1, 3, 5, 7]))
    puts "17"
    assert_equal(-1, chop(4, [1, 3, 5, 7]))
    puts "18"
    assert_equal(-1, chop(6, [1, 3, 5, 7]))
    puts "19"
    assert_equal(-1, chop(8, [1, 3, 5, 7]))
    
  rescue
    puts "ERROR: " + $!
  end



puts "Executing Hassan Chop!"


#array = make_array(20)
#puts "Item index: " + chop(5, [1, 3, 5]).to_s

test_chop




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
