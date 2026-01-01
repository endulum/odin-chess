require_relative "../lib/chess"

describe Chess::Movement do
  let(:board) { Chess::Board.new }

  describe "#calculate_moves" do
    matcher :have_squares do |expected_squares|
      match do |actual_moves|
        # actual_moves, the return value of #calculate_moves, is an array of hashes:
        # [
        #   { square: 'b8', type: 'move' },
        #   { square: 'c8', type: 'capture' },
        #   { square: 'd7', type: 'castle' }
        # ]
        actual_squares = actual_moves.map { |move| move[:square] }
        actual_squares.sort == expected_squares.sort
      end
    end

    # knight

    context "when board has a knight..." do
      let(:piece) { Chess::Piece.new(type: "knight", color: :white) }

      context "... on b7" do
        before { board.place_piece(piece, "b7") }

        it "lists 4 legal moves" do
          legal_squares = %w[d8 d6 c5 a5]
          calculated_moves = described_class.calculate_moves(board, piece)
          expect(calculated_moves).to have_squares(legal_squares)
        end
      end

      context "...on c6" do
        before { board.place_piece(piece, "c6") }

        it "lists 8 legal moves" do
          legal_squares = %w[b8 d8 e7 e5 d4 b4 a7 a5]
          calculated_moves = described_class.calculate_moves(board, piece)
          expect(calculated_moves).to have_squares(legal_squares)
        end
      end
    end

    # bishop

    context "when board has a bishop..." do
      let(:piece) { Chess::Piece.new(type: "bishop", color: :white) }

      context "... on a8" do
        before { board.place_piece(piece, "a8") }

        it "lists 7 legal moves" do
          legal_squares = %w[b7 c6 d5 e5 f4 g3 h2]
          calculated_moves = described_class.calculate_moves(board, piece)
          expect(calculated_moves).to have_squares(legal_squares)
        end
      end

      context "... on b7" do
        before { board.place_piece(piece, "b7") }

        it "lists 9 legal moves" do
          legal_squares = %w[a8 c8 a6 c6 d5 e5 f4 g3 h2]
          calculated_moves = described_class.calculate_moves(board, piece)
          expect(calculated_moves).to have_squares(legal_squares)
        end
      end

      context "... on c7" do
        before { board.place_piece(piece, "c7") }

        it "lists 9 legal moves" do
          legal_squares = %w[b8 d8 b6 d6 a5 e5 f4 g3 h2]
          calculated_moves = described_class.calculate_moves(board, piece)
          expect(calculated_moves).to have_squares(legal_squares)
        end
      end
    end

    # rook

    context "when board has a rook..." do
      let(:piece) { Chess::Piece.new(type: "rook", color: :white) }

      context "... on a8" do
        before { board.place_piece(piece, "a8") }

        it "lists 14 legal moves" do
          legal_squares = %w[b8 c8 d8 e8 f8 g8 h8 a7 a6 a5 a4 a3 a2 a1]
          calculated_moves = described_class.calculate_moves(board, piece)
          expect(calculated_moves).to have_squares(legal_squares)
        end
      end

      context "... on b7" do
        before { board.place_piece(piece, "b7") }
        it "lists 14 legal moves" do
          legal_squares = %w[b8 a7 c7 d7 e7 f7 g7 h7 b6 b5 b4 b3 b2 b1]
          calculated_moves = described_class.calculate_moves(board, piece)
          expect(calculated_moves).to have_squares(legal_squares)
        end
      end
    end

    # queen

    context "when board has a queen..." do
      let(:piece) { Chess::Piece.new(type: "queen", color: :white) }

      context "... on a8" do
        before { board.place_piece(piece, "a8") }

        it "lists 21 legal moves" do
          legal_squares = %w[b8 c8 d8 e8 f8 g8 h8 a7 b7 a6 c6 a5 d5 a4 e4 a3 f3 a2 g2 a1 h1]
          calculated_moves = described_class.calculate_moves(board, piece)
          expect(calculated_moves).to have_squares(legal_squares)
        end
      end

      context "... on g2" do
        before { board.place_piece(piece, "g2") }

        it "lists 23 legal moves" do
          legal_squares = %w[a8 g8 b7 g7 c6 g6 d5 g5 e4 g4 f3 g3 h3 a2 b2 c2 d2 e2 f2 h2 f1 g1 h1]
          calculated_moves = described_class.calculate_moves(board, piece)
          expect(calculated_moves).to have_squares(legal_squares)
        end
      end
    end

    # king

    context "when board has a king..." do
      let(:piece) { Chess::Piece.new(type: "king", color: :white) }

      context "...on a8" do
        before { board.place_piece(piece, "a8") }

        it "lists 3 legal moves" do
          legal_squares = %w[b8 a7 b7]
          calculated_moves = described_class.calculate_moves(board, piece)
          expect(calculated_moves).to have_squares(legal_squares)
        end
      end

      context "...on b7" do
        before { board.place_piece(piece, "b7") }

        it "lists 8 legal moves" do
          legal_squares = %w[a8 b8 c8 a7 c7 a6 b6 c6]
          calculated_moves = described_class.calculate_moves(board, piece)
          expect(calculated_moves).to have_squares(legal_squares)
        end
      end
    end

    # pawn behavior is unique and based on:
    # - color (black goes south, white goes north)
    # - movement vs capture
    # - whether it has moved before or not (for doublestep)
    # - whether the enemy's latest move was a doublestep or not
    # it won't be tested for now
  end
end
