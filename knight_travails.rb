require 'pry'

class Knight
  # Acts as a node with parent defined, and a maximum of 8 children.
  attr_accessor :possible_moves
  attr_reader :cur_pos, :parent

  @@moves = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [2, -1], [2, 1], [1, -2], [1, 2]]

  # Places node on board
  def initialize(cur_pos, board, parent = nil)
    @parent = parent
    @cur_pos = cur_pos
    @possible_moves = @@moves.map { |move| 
      [cur_pos[0] + move[0], cur_pos[1] + move[1]]
    }
    @possible_moves.map! { |move| 
      board.in_board?(move) ? move : nil
    }
  end
end

class Board
  attr_reader :board

  def initialize(width, height)
    @height = height
    @width = width
    @board = create_board(width, height)
  end

  def create_board(width, height)
    board = []
    height.times do |j|
      width.times do |i|
        board << [i + 1, j + 1]
      end
    end
    board
  end

  def in_board?(position)
    board.include?(position)
  end

  def build_tree(node)
    existing_nodes = []
    queue = []
    queue << node
    until queue.empty?
      first_in_queue = queue.shift
      first_in_queue.possible_moves.map! { |move| 
        next if move.nil? || existing_nodes.include?(move)

        child_node = Knight.new(move, self, first_in_queue)
        existing_nodes << move
        queue << child_node
        child_node
      }
    end
  end
  
  # inds the destination node in the tree
  def find_destination(node, dest)
    queue = []
    list = []
    queue << node
    until queue.empty?
      first_in_queue = queue.shift
      list << first_in_queue.cur_pos
      first_in_queue.possible_moves.each { |move|
        next if move.nil? 
        return move if move.cur_pos == dest

        queue << move unless move.nil?
      }
    end
  end

  # Takes destination node, returns the list of moves as an array
  def list_route(node, list = [])
    list.unshift(node.cur_pos)
    return list if node.parent.nil?

    list_route(node.parent, list)
  end

  def king_travails(start, finish)
    start = Knight.new(start, self)
    build_tree(start)
    first_dest = find_destination(start, finish)
    route = list_route(first_dest)
    p route
  end
end



board1 = Board.new(8,8)

binding.pry