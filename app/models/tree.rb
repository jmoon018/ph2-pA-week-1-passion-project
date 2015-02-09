MIN_INT = -2_147_483_648
MAX_INT = 2_147_483_647 # a friendly reminder that you wasted an hour before figuring out that sh-t wasn't to be positive.. never forget


class Tree < ActiveRecord::Base
  belongs_to :user
  has_one :node

  # node count
  def node_count
    depth_first_search.count
  end

  # default is root
  def depth_first_search(node = self.node)
    # base case
    #puts "Depth first search on: #{node}..#{node.value.to_s}"
    if node.nodes.empty?
      #puts "Node w/ value #{node.value.to_s} is empty!"
      return [node]
    else
      theReturn = [node]
      node.nodes.each {|n| theReturn = theReturn + depth_first_search(n)}
      # return ([node] + node.nodes.each {|n| depth_first_search(n)})
      return theReturn
    end
  end

  # this is a breadth first search
  def nodes_by_level (depth, node = self.node)
    if depth == 0
      return [node]
    elsif !node.nodes.empty?
      nodes = []
      node.nodes.each {|n| nodes = nodes + nodes_by_level(depth-1, n)}
      return nodes
    else
      return []
    end
  end

  # Return the minimax value of a node
  def minimax (args)
    node = args[:node] || self.node
    depth = args[:depth] || 10
    maximize_it = args[:maximize]
    value = node.value
    nodes = node.nodes

    if nodes.empty? || depth == 0
      return node.value

    # we want to pick the child with the HIGHEST value
    elsif maximize_it
      biggest_value = MIN_INT
      nodes.each do |child_node|
        value = minimax({node: child_node, maximize: false, depth: depth-1})
        # pick the bigger of the two
        biggest_value =  [value, biggest_value].max
      end
      return biggest_value

    # we want to pick the child with the SMALLEST value
    elsif !maximize_it
      smallest_value = MAX_INT
      nodes.each do |child_node|
        value = minimax({node: child_node, maximize: true, depth: depth-1})
        smallest_value = [value, smallest_value].min
      end
      return smallest_value
    end
  end
end
