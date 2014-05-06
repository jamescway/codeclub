require 'digest'
require 'murmurhash3'  #gem install murmurhash3

class BloomFilter

  def initialize(size=9_000_000)
    @size = size
    @num_inputs = 0
    @bloom_filter = Array.new(size)
    @bloom_filter.fill(0)
  end

  def hash_md5(str, shift=0)
    Integer('0x' + Digest::MD5.hexdigest(str)) >> shift
  end

  def hash_murmur(str)
    MurmurHash3::V32.str_hash(str)
  end

  def load_words(filename)
    File.open(filename).each_with_index  do |word, i|
      print "." if i % 10000 == 0
      next if word==nil or word==""
      word.strip!.downcase

      hashes = []
      hashes << hash_md5(word)    % @size
      hashes << hash_murmur(word) % @size
      hashes << hash_md5(word,10)  % @size
      hashes << hash_md5(word,90) % @size

      hashes.each { |hash| @bloom_filter[hash] = 1 }

      @num_inputs = i if i > @num_inputs
    end
  end

  def in_filter?(word)
    hashes = []
    hashes << hash_md5(word)     % @size
    hashes << hash_murmur(word)  % @size
    hashes << hash_md5(word, 10)  % @size
    hashes << hash_md5(word, 90) % @size

    result = true
    hashes.each do |hash|
      result = false if @bloom_filter[hash] != 1      
    end
    result
  end

  def percent_false_positive
    num_hashes = 4.0
    (((  1-Math.exp( (-num_hashes * @num_inputs)/(@size) )  )**num_hashes)*100).round(6)
  end

  def check_dictionary(filename)
    File.open(filename).each_with_index do |word, i|
      if !in_filter?(word.strip.downcase)
        p "#{word}(#{i}) wasn't in filter!!"
        break
      end
    end
  end
end