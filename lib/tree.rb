require_relative "./node"
require_relative "./display"

class Tree
  include Display

  private

  attr_accessor :root

  public

  def initialize
    self.root = nil
  end

  def build_tree(array)
    return if array.empty?

    prep_array = array.uniq.sort
    mid = prep_array.length / 2
    return new_node(prep_array[0]) if prep_array.length.eql?(1)

    node = new_node(prep_array[mid])
    node.left_node = build_tree(prep_array[0...mid])
    node.right_node = build_tree(prep_array[(mid + 1)..])

    self.root = node
  end

  def insert(value, current_node = root)
    if current_node.data > value
      current_node.left_node ? insert(value, current_node.left_node) : current_node.left_node = new_node(value)
    elsif current_node.data < value
      current_node.right_node ? insert(value, current_node.right_node) : current_node.right_node = new_node(value)
    end
  end

  def delete(value, current_node = root)
    return "error, node does not exist" unless find(value)
    # 3 cases to deal with.
    target = find(value)
    parent = find_parent(target)

    # case 1: node is leaf
    if target.leaf?
      parent.left_node.eql?(target) ? parent.left_node = nil : parent.right_node = nil
    # case 2: node has 1 child
    elsif target.single_child?
      if parent.left_node.eql?(target)
        parent.left_node = target.left_node || target.right_node
      else
        parent.right_node = target.left_node || target.right_node
      end
    # case 3: node has two children
    else
      successor = target.right_node.find_min
      if target.right_node.eql?(successor)
        parent.left_node.eql?(target) ? parent.left_node = successor : parent.right_node = successor
        successor.left_node = target.left_node
      else
        suc_parent = find_parent(successor)
        parent.left_node.eql?(target) ? parent.left_node = successor : parent.right_node = successor
        suc_parent.left_node = successor.right_node
        successor.right_node = target.right_node
        successor.left_node = target.left_node
      end
    end
    target
  end

  def find(value, current_node = root)
    return nil if current_node.nil?
    return current_node if current_node.data.eql?(value)

    node = new_node(value)
    (current_node > node) ? find(value, current_node.left_node) : find(value, current_node.right_node)
  end

  def level_order(result = [], queue = [], &block)
    # root moves into queue. parent.left_node moves into queue. parent.right_node moves into queue. root moves into result.
    queue << root
    until queue.empty?
      node = queue.shift
      result << (block ? yield(node) : node.data)
      queue << node.left_node if node.left_node
      queue << node.right_node if node.right_node
    end
    result
  end

  def preorder(node = root, result = [], &block)
    return result if node.nil?

    result << (block ? yield(node) : node.data)
    preorder(node.left_node, result, &block)
    preorder(node.right_node, result, &block)
    result
  end

  def inorder(node = root, result = [], &block)
    return result if node.nil?

    inorder(node.left_node, result, &block)
    result << (block ? yield(node) : node.data)
    inorder(node.right_node, result, &block)
    result
  end

  def postorder(node = root, result = [], &block)
    return result if node.nil?

    postorder(node.left_node, result, &block)
    postorder(node.right_node, result, &block)
    result << (block ? yield(node) : node.data)
    result
  end

  # count edges from node to furthest leaf. To do this, find all leaves, and count edges against node. Largest distance is height?
  def height(node)
    return 0 if node.leaf?

    leaf_pile = inorder(node) { |node| node if node.leaf? }.compact
    leaf_pile.map { |leaf| edge_count(leaf, node) }.max
  end

  # count edges from node to root.
  def depth(node)
    return 0 if node.eql?(root)
    edge_count(node, root)
  end

  # check left and right depth. Compare "deepest" node on each side. If > 1, return false
  def balanced?(current_node = root)
    return true if current_node.nil?

    left_height = height(current_node.left_node) if current_node.left_node
    right_height = height(current_node.right_node) if current_node.right_node
    (left_height - right_height).abs <= 1
  end

  # check if balanced? returns false. If false, run #inorder method, then pass that into #build_tree
  def rebalance
    return "Tree is already balanced" if balanced?
    build_tree(inorder)
  end

  private

  def find_parent(node, current_node = root)
    return nil if current_node.nil?
    return current_node if current_node.parent?(node)

    (node < current_node) ? find_parent(node, current_node.left_node) : find_parent(node, current_node.right_node)
  end

  def edge_count(start_node, end_node)
    count = 0
    until start_node.eql?(end_node)
      start_node = find_parent(start_node)
      count += 1
    end
    count
  end

  def new_node(value)
    Node.new(value)
  end
end
