require_relative "./node"
require_relative "./display"

class Tree
  include Display
  attr_accessor :root

  def initialize(array)
    @array = array
    @root = build_tree(array)
  end

  def build_tree(array)
    return if array.empty?

    sorted_array = array.uniq.sort
    mid = sorted_array.length / 2
    return new_node(sorted_array[0]) if sorted_array.length.eql?(1)

    node = new_node(sorted_array[mid])
    node.left_node = build_tree(sorted_array[0...mid])
    node.right_node = build_tree(sorted_array[(mid + 1)..])

    @root = node
  end

  def new_node(value)
    Node.new(value)
  end
end
