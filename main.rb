require_relative "lib/tree"
require_relative "lib/node"
require_relative "lib/display"

def driver
  arr = (Array.new(15) { rand(1..100) })
  tree_1 = Tree.new
  tree_1.build_tree(arr)
  p "Tree balanced: #{tree_1.balanced?}"
  puts "level order: \t#{tree_1.level_order}\n" \
    "preorder: \t#{tree_1.preorder}\n" \
    "postorder: \t#{tree_1.postorder}\n" \
    "inorder: \t#{tree_1.inorder}\n\n"
  tree_1.pretty_print
  tree_1.insert(101)
  tree_1.insert(1121)
  tree_1.insert(11023)
  p "Tree balanced: #{tree_1.balanced?}"
  tree_1.rebalance
  p "Tree balanced: #{tree_1.balanced?}"
  puts "level order: \t#{tree_1.level_order}\n" \
  "preorder: \t#{tree_1.preorder}\n" \
  "postorder: \t#{tree_1.postorder}\n" \
  "inorder: \t#{tree_1.inorder}\n\n"
  tree_1.pretty_print
end
driver
