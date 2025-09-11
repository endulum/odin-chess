module Chess
  # the chess board
  class Board
    ROWS = %w[8 7 6 5 4 3 2 1].freeze
    COLS = %w[a b c d e f g h].freeze

    def initialize
      pairs = ROWS
              .product(COLS)
              .map { |row, col| col + row }
      @squares = Hash.new(64)
      pairs.each { |x| @squares[x] = nil }
    end

    def all_squares
      @squares.clone
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

      return if @squares[starting].nil?

      piece = @squares[starting]
      @squares[starting] = nil
      @squares[ending] = piece
    end

    def translate(notation, direction)
      return nil unless @squares.key?(notation)

      col, row = notation.chars
      horiz, verti = direction
      col = x_translate(col, horiz)
      row = y_translate(row, verti)
      row.nil? || col.nil? ? nil : [col, row].join
    end

    def print(highlighted = [])
      rows = @squares.keys.each_slice(8).to_a
      board_string = "  a b c d e f g h".gray

      rows.each_with_index do |row, row_index|
        board_string += "\n#{ROWS[row_index].gray} "
        row.each_with_index do |notation, index|
          board_string += print_square(notation, highlighted, index, row_index)
        end
      end

      board_string
    end

    private

    def x_translate(col, horiz)
      return col if horiz.zero?

      new_index = COLS.index(col) + horiz
      new_index.positive? ? COLS[new_index] : nil
    end

    def y_translate(row, verti)
      return row if verti.zero?

      new_index = ROWS.index(row) - verti
      new_index.positive? ? ROWS[new_index] : nil
    end

    def print_square(notation, highlighted, index, row_index)
      content = at_square(notation)
      content_string = content ? "#{content.character.bold} " : "  "

      is_even = (index + row_index).even?
      background_color = background_color_from(notation, highlighted, is_even)

      content_string.colorize(color: :black, background: background_color)
    end

    def background_color_from(notation, highlighted, is_even)
      is_even ? :gray : :white

      # return default_background unless highlighted.include?(notation)

      # is_free = @squares[notation].nil?
      # is_free ? :green : :red
    end
  end
end
