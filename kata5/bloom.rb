require 'digest'
require 'murmurhash3'  #gem install murmurhash3
require 'trollop'
require 'debugger'

class BloomFilter

  def initialize(size)
    @size = size.to_i || 9_000_000
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
    false_positives = 0
    File.open(filename).each_with_index  do |word, i|
      if word
        p "#{i}" if i % 10000 == 0
        word = word.downcase.strip!
        hashes = []
        hashes << hash_md5(word)    % @size
        hashes << hash_murmur(word) % @size
        hashes << hash_md5(word,5)  % @size
        hashes << hash_md5(word,10) % @size

        res = check_stuff(hashes)
        false_positives += 1 if res

        hashes.each { |hash| @bloom_filter[hash] = 1 }

        @num_inputs = i if i > @num_inputs
      end
    end
    puts "False Positives: #{false_positives}"
  end

  def check_stuff(hashes)
    r1 = @bloom_filter[hashes[0]] == 1
    r2 = @bloom_filter[hashes[1]] == 1
    r3 = @bloom_filter[hashes[2]] == 1
    r4 = @bloom_filter[hashes[3]] == 1
    r1 && r2 && r3 && r4
  end

  def in_filter?(word)
    # debugger
    hashes = []
    hashes << hash_md5(word)     % @size
    hashes << hash_murmur(word)  % @size
    hashes << hash_md5(word, 5)  % @size
    hashes << hash_md5(word, 10) % @size

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
      if !in_filter?(word.downcase.strip!)
        p "#{word}(#{i}) wasn't in filter!!"
        break
      end
    end
  end
end

opts = Trollop::options do
  opt :size, "size", :default => 9_000_000  # integer --size <i>, default to 2_000_000
  opt :word, "word", :type => :string
end

bf = BloomFilter.new(opts[:size])
puts "Filter Size: #{opts[:size]}"
bf.load_words("/usr/share/dict/words")
p "FALSE POSITIVES: #{bf.percent_false_positive}%"
#bf.check_dictionary("/usr/share/dict/words")

r = bf.in_filter?(opts[:word])
puts "#{opts[:word]} is in filter: #{r}"




