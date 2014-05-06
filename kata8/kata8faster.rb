####Log####
#removed some methods
#removed to_sym
#removed letters
#used << shovel operator

require 'benchmark'
require 'profiler'

class Wordfinder
  attr_accessor :dictionary, :matches
  
  DICT_SAVEFILE = "serialized_dictionary"
  WORDS_FILE    = "/usr/share/dict/words"

  def initialize
    @dictionary = {}
    load_dictionary
    @matches = []
  end
  def save_dictionary
    if !File.exists?(DICT_SAVEFILE)
      File.open(DICT_SAVEFILE, "w") do | file |
        Marshal.dump(@dictionary, file)
      end
    end
  end
  def load_dictionary
    if File.exists?(DICT_SAVEFILE)
      File.open(DICT_SAVEFILE) do | file |
        @dictionary = Marshal.load(file)
      end
    else
      load_file(WORDS_FILE)
      save_dictionary
    end
  end
  def load_file(words_file)
    File.open(words_file).each do |word|
      if word.strip.size  <= 6
        @dictionary[word.downcase.strip] = 1 
      end
    end
  end
  def read_all_the_words
    count = 0
    @dictionary.each do |key, val|
      word = key.to_s
      if word.size == 6
        count += 1
        original_word = word.dup
        word = word.dup
        word1 = ''
        while !word.empty? do
          word1 << word.slice!(0)      
          if (@dictionary[word1] == 1) && 
             (@dictionary[word]  == 1) && 
             word1.size > 1 && 
             word.size > 1
            @matches << original_word
          end
        end
      end
    end
    puts "Six Letter Words: #{count}"
  end
end

word_finder = Wordfinder.new
GC.start
word_finder.read_all_the_words
puts "Count: " + word_finder.matches.size.to_s
