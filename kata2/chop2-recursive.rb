#!/usr/bin/ruby

require 'test/unit'
extend Test::Unit::Assertions

def r_chop(l,r,array, int)
  if array.size < 1
    return -1
  end
  
  if (r-l) <= 1
    if array[l] == int
      return l
    elsif array[r] == int
      return r
    else
      return -1
    end
  end
  
  m = (l+r)/2
  puts "L: #{l} R: #{r}   M:#{m}"
  if(int < array[m])
    l = l
    r = m
  else
    l = m
    r = r
  end

  r_chop(l,r,array, int)
end

def chop(int, array)
  l = 0
  r = array.size - 1
  return r_chop(l, r, array, int)
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
#puts "item index: " + chop(5, array).to_s

test_chop
