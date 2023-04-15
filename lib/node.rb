require_relative "./comparable"

class Node
  include Comparable

  attr_reader :data
  attr_accessor :left_node, :right_node

  def initialize(data)
    @data = data
    @left_node = nil
    @right_node = nil
  end

  def parent?(node)
    left_node.eql?(node) || right_node.eql?(node)
  end

  def leaf?
    left_node.nil? && right_node.nil?
  end

  def single_child?
    (left_node && !right_node) || (right_node && !left_node)
  end

  def find_min
    node = self
    node = node.left_node until node.left_node.nil?
    node
  end
end
