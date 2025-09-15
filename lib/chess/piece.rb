module Chess
  # a moveable piece in Chess
  class Piece
    CHARSET = {
      "white" => {
        "king" => "♔",
        "queen" => "♕",
        "rook" => "♖",
        "bishop" => "♗",
        "knight" => "♘",
        "pawn" => "♙"
      },
      "black" => {
        "king" => "♚",
        "queen" => "♛",
        "rook" => "♜",
        "bishop" => "♝",
        "knight" => "♞",
        "pawn" => "♟"
      }
    }.freeze

    attr_reader :type, :color, :character

    def initialize(**traits)
      @type = traits[:type]
      @color = traits[:color]
      @character = CHARSET[color][type]
    end
  end
end
