# A   B   C
# B   C   E
# C   G
# D   A   F
# E   F
# F   H
require 'rgl/adjacency'
require 'rgl/traversal'
require 'rgl/dot'
require 'test/unit'
require 'ruby-debug'
extend Test::Unit::Assertions

class JonnyDep
  def initialize
    @graf = RGL::DirectedAdjacencyGraph.new
  end

  def add_direct(vertex, deps)
    @graf.add_vertex(vertex)
    deps.each do |dep_vertex|
      @graf.add_edge(vertex, dep_vertex)
    end
  end

  def write_to_file
    @graf.write_to_graphic_file('jpg')
    %x[open graph.jpg]
  end

  def dependencies_for(vertex)
    res = @graf.bfs_search_tree_from(vertex)
    x = res.edges.collect(&:target).sort
    puts x.inspect
    x
  end
end


class MyTest < Test::Unit::TestCase
  def test_basic
    dep = JonnyDep.new
    dep.add_direct('A', %w{ B C } )
    dep.add_direct('B', %w{ C E } )
    dep.add_direct('C', %w{ G   } )
    dep.add_direct('D', %w{ A F } )
    dep.add_direct('E', %w{ F   } )
    dep.add_direct('F', %w{ H   } )
    # dep.write_to_file

    assert_equal( %w{ B C E F G H },   dep.dependencies_for('A'))
    assert_equal( %w{ C E F G H },     dep.dependencies_for('B'))
    assert_equal( %w{ G },             dep.dependencies_for('C'))
    assert_equal( %w{ A B C E F G H }, dep.dependencies_for('D'))
    assert_equal( %w{ F H },           dep.dependencies_for('E'))

    dep2 = JonnyDep.new
    dep2.add_direct('A', %w{ B } )
    dep2.add_direct('B', %w{ A } )

    assert_equal( %w{ B }, dep2.dependencies_for('A'))
  end
end

puts "RRRRRRRrrrrRRRRRRrrRRRRRR!"

MyTest.new('test_basic')

