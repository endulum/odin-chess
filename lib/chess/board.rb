module Chess
  # the chess board
  class Board
    ROWS = %w[1 2 3 4 5 6 7 8].freeze
    COLS = %w[a b c d e f g h].freeze

    attr_reader :squares

    def initialize
      pairs = COLS
              .product(ROWS)
              .map { |col, row| col + row }
      @squares = Hash.new(64)
      pairs.each { |x| @squares[x] = nil }
    end

    def at_square(notation)
      return unless @squares.key? notation

      @squares[notation]
    end

    def place_piece(piece, notation)
      return unless @squares.key? notation

      @squares[notation] = piece
    end

    def move_piece(starting, ending)
      return unless @squares.key?(starting) && @squares.key?(ending)

      return if squares[starting].nil?

      piece = squares[starting]
      squares[starting] = nil
      squares[ending] = piece
    end

    def translate(notation, direction)
      return nil unless @squares.key?(notation)

      col, row = notation.chars
      horiz, verti = direction
      col = x_translate(col, horiz)
      row = y_translate(row, verti)
      row.nil? || col.nil? ? nil : [col, row].join
    end

    private

    def x_translate(col, horiz)
      return col if horiz.zero?

      new_index = COLS.index(col) + horiz
      new_index.positive? ? COLS[new_index] : nil
    end

    def y_translate(row, verti)
      return row if verti.zero?

      new_index = ROWS.index(row) + verti
      new_index.positive? ? ROWS[new_index] : nil
    end
  end
end
