require 'rgl/adjacency'
require 'rgl/traversal'
require 'rgl/dot'
require 'rgl/topsort'
require 'rgl/implicit'
require 'ruby-debug'
require 'test/unit'
extend Test::Unit::Assertions

class Chain
  def initialize
    @file = 'easy_input.txt'
    @graf = RGL::AdjacencyGraph.new
    @hash = {}
  end

  def insert_node(word)
    @graf.add_vertex(word)
    create_edges(word)
  end

  def write_to_file
    @graf.write_to_graphic_file('jpg')
    %x[open graph.jpg]
  end

  def build_hash
    File.open(@file).each do |word|
      word.strip!
      if word != ""
        @hash[word.size] ||= []
        @hash[word.size] << word
      end
    end
  end

  def find_similar(word)
    word_array = word.chars.to_a
    @hash[word.size].inject([]) do |list, current_word|
      difference = current_word.chars.to_a - word_array
      list << current_word if difference && difference.size == 1
      list
    end
  end

  def create_edges(word)
    find_similar(word).each do |similar_word|
      @graf.add_edge(word, similar_word)
    end
  end

  def load_graf
    File.open(@file).each do |word|
      insert_node(word.strip) if word.strip != ""
    end
  end

  def create_chain(start_word, end_word)
    puts "\n#{start_word} --> #{end_word}"
    result = []
    vis = RGL::DFSVisitor.new(@graf)
    vis.set_examine_vertex_event_handler { |v| result.push "#{v}" }
    vis.set_finish_vertex_event_handler { |v| result.pop }
    @graf.depth_first_visit(start_word, vis) do |x|
      if x == end_word
        result.push(end_word)
        break
      end
    end
    puts result.to_s
    result
  end

  def load_all_the_things
    build_hash
    load_graf
    write_to_file
  end
end


class MyTest < Test::Unit::TestCase
  def test_things
    chain = Chain.new
    chain.load_all_the_things

    assert_equal( %w{ cot cog dog dig },         chain.create_chain("cot", "dig"))
    assert_equal( %w{ cat cot cog dog },         chain.create_chain("cat", "dog"))
    assert_equal( %w{ dog cog cot },             chain.create_chain("dog", "cot"))
    assert_equal( %w{ cot cog dog dig dip did }, chain.create_chain("cot", "did"))
  end
end

MyTest.new('test_things')
