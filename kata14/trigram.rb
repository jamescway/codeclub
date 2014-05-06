class Trigram
  def initialize
    @trigrams = Hash.new
  end

  def load(file)
    File.open(file).each do |line|
      parse_into_trigrams line
    end
  end

  def parse_into_trigrams(line)
    word1, word2 = "", ""
    line.split(" ").each do |word|
      (word1 = word; next) if word1.empty?
      (word2 = word; next) if word2.empty?
      @trigrams["#{word1} #{word2}"] ||= []
      @trigrams["#{word1} #{word2}"] << word
      word1 = word2; word2 = word
    end
    # p @trigrams
  end

  def print_book
    outfile = File.open("output.txt", "w")
    book = ""
    first_words = random_start_words
    book << first_words
    key = first_words

    word = rand_next_word(key)
    while word
      key = last_word_in_str(key) + " " + word
      book << " #{word}"
      word = rand_next_word(key)
      print_debug(book, key) if ENV['DEBUG']
    end
    book
  end

  def print_debug(book, key)
    puts book + " [+ " + key.split(" ")[-1] + "]"
  end

  def last_word_in_str(key)
    key.split(" ")[-1]
  end

  def random_start_words
    @trigrams.keys[rand(@trigrams.keys.size)]
  end

  def rand_next_word(words)
    @trigrams[words][rand(@trigrams[words].size)] rescue nil
  end
end


trigram = Trigram.new
trigram.load("book.txt")
puts "BOOK: #{trigram.print_book}"


# Algo

# needs to parse stuff inside delimiters
#   -quotes
#   -parenthesis, (), {}, []

# Ignore:
#   -punctuation
#   -special characters (i.e. non-"" () )


# OR

# remove all punctuation
#   -maybe even periods
#













