module Chess
  # governance of how each piece type moves
  module Movement
    DIRECTIONS = {
      "straight" => {
        "north" => [0, 1],
        "south" => [0, -1],
        "west" => [-1, 0],
        "east" => [1, 0]
      },
      "diagonal" => {
        "northeast" => [1, 1],
        "southwest" => [-1, -1],
        "southeast" => [1, -1],
        "northwest" => [-1, 1]
      }
    }.freeze

    KNIGHT_MOVES = [
      [-2, -1],
      [-1, -2],
      [2, 1],
      [1, 2],
      [-2, 1],
      [-1, 2],
      [2, -1],
      [1, -2]
    ].freeze

    def self.legal_moves(piece, board)
      @board = board
      @piece = piece
      moves_for_type
    end

    private

    def moves_for_type
      # invokes any one of the below methods based on the type of Piece
      moves = {
        "king" => :king_moves,
        "queen" => :queen_moves,
        "rook" => :rook_moves,
        "knight" => :knight_moves,
        "bishop" => :bishop_moves,
        "pawn" => :pawn_moves
      }
      send(moves[@piece.type])
    end

    def king_moves
      # can move one square all directions
    end

    def queen_moves
      # can move unlimited squares all directions
    end

    def rook_moves
      # can move unlimited squares straight directions
    end

    def knight_moves
      # has own moveset
    end

    def bishop_moves
      # can move unlimited squares diagonal directions
    end

    def pawn_moves
      # has special moves
    end
  end
end
