require 'letters'

class Wordfinder
  attr_accessor :dictionary, :matches
  
  DICT_SAVEFILE = "serialized_dictionary"
  WORDS_FILE    = "/usr/share/dict/words"

  def initialize
    @dictionary = {}
    "Loading Dictionary".o
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
    end
  end

  def load_file(words_file)
    File.open(words_file).each do |word|
      if word.strip.size  <= 6
        @dictionary[word.downcase.strip.to_sym] = 1 
      end
    end
  end


  def read_all_the_words
    @dictionary.each do |key, val|
      word = key.to_s
      if word.size == 6
        process_sub_words(word)
      end
    end
  end

  def process_sub_words(word)
    original_word = word.dup
    word1 = ""
    word = word.dup
    while !word.empty? do
      word1 << word.slice!(0)      
      #if is_word?(word1) && is_word?(word)
      if (@dictionary[word1.to_sym] == 1) && 
         (@dictionary[word.to_sym]  == 1)
        @matches << original_word
      end
    end
  end

  # def is_word?(word)
  #   @dictionary[word.to_sym] == 1
  # end

  # def write_matches
  #   File.open("output", "w") do |file|
  #     @matches.each {|m| file.write("#{m}\n") }
  #   end
  # end
end


word_finder = Wordfinder.new
#word_finder.save_dictionary
word_finder.read_all_the_words
#word_finder.write_matches
puts "Count: " + word_finder.matches.size.to_s
