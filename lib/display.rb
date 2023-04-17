module Display
  def pretty_print(node = root, prefix = "", is_left = true)
    pretty_print(node.right_node, "#{prefix}#{is_left ? "│   " : "    "}", false) if node.right_node
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.data}"
    pretty_print(node.left_node, "#{prefix}#{is_left ? "    " : "│   "}", true) if node.left_node
  end
end
