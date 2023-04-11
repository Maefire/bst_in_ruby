class Node
  attr_reader :value
  attr_accessor :left_node, :right_node

  def initialize(value, left_node = nil, right_node = nil)
    @value = value
    @left_node = left_node
    @right_node = right_node
  end

  def parent?(node)
    left_node.eql?(node) || right_node.eql?(node)
  end
end
