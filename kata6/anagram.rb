require File.expand_path(File.join(File.dirname(__FILE__), "bloom.rb"))

class String
  def each_char_with_index
    0.upto(size - 1) do |index|
      yield(self[index..index], index)
    end
  end
  def remove_char_at(index)
    return self[1..-1] if index == 0
    self[0..(index-1)] + self[(index+1)..-1]
  end
end

class Anagram
  def initialize
    @bf = BloomFilter.new(20000000)
    p "Loading Bloom Filter"
    @bf.load_words('/usr/share/dict/words')
    p "FALSE POSITIVES: #{@bf.percent_false_positive}%"
  end

  def loadfile(file)
    f = File.open('output.txt', 'w')
    File.open(file).each do |word|
      f.print check_anagrams(word.strip.downcase)
      f.write "\n"
    end
    f.close
  end

  def check_anagrams(word)
    puts "checking anagrams for...#{word}"

    res = []
    permute(word).each do |combo|
      next if combo==''
      if @bf.in_filter?(combo)
        res << combo  
      end
    end
    res.uniq
  end

  def permute(str, prefix = '')
    return prefix if str.size == 0
    res = []
    str.each_char_with_index do |char, index|
      res << permute(str.remove_char_at(index), prefix + char)
    end
    res.flatten
  end
end


a = Anagram.new
#a.loadfile("input.txt")
#a.loadfile("easy_input.txt")
p a.check_anagrams("baseliners")

#Notes
#----------------------------------------------------------
#                          permute(abc, '')
#        bc, a                ac, b              ab, c
#        /    \               /    \             /    \
#     c, ab   b,ac        c, ba   a,bc        b,ca    a,cb
#      /        \           /        \         /        \
#   '',abc    '',bac     '', bac    '',bca  '',cab     '',acb
    
# Challenges           
#--------------------------------------------------------
# 1. permute method not easy_input, copied method
# 2. had false positives, tweaked bloom filter size, and hashes(4) and method of hashing
#    a. because of large number of permutations (3mil) you start seeing false positives, 
#       better hashing and larger filter reduced this
# 3. marshal.dump/load the bloom filter for fasterness
#
#
#