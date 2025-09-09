require_relative "../lib/chess"

describe Chess::Board do
  subject(:board) { described_class.new }

  # the data structure for the board's contents is going to be a single-layer hash
  # { "a8" => nil, "a7" => nil, "a6" => <Piece...>, "a5" => nil, ... }
  # the keys are Chess notation we understand and, with this hash,
  # the program understands (without some translating intermediary) too.
  # because the board is a 2d grid it does "make sense" to use 2d coordinates,
  # but i do want to stick to using chess notation when i can, it makes sense.

  # at the Board class i want these constants:
  # ROWS = %w[1 2 3 4 5 6 7 8]
  # COLS = %w[a b c d e f g h]
  # Chess::Board can use these to create the board and translate squares.

  describe "#initialize" do
    it "has all the right squares" do
      expected_keys = %w[
        a8 a7 a6 a5 a4 a3 a2 a1
        b8 b7 b6 b5 b4 b3 b2 b1
        c8 c7 c6 c5 c4 c3 c2 c1
        d8 d7 d6 d5 d4 d3 d2 d1
        e8 e7 e6 e5 e4 e3 e2 e1
        f8 f7 f6 f5 f4 f3 f2 f1
        g8 g7 g6 g5 g4 g3 g2 g1
        h8 h7 h6 h5 h4 h3 h2 h1
      ]
      board_keys = board.squares.keys
      expect(board_keys).to contain_exactly(expected_keys)
    end
  end

  # there is one place for 2d coordinates and it is spatial translation,
  # because the pieces need some idea of "up", "down", "left", "right"...

  describe "#translate" do
    context "starting from a8" do
      starting = "a8"

      context "going one space north" do
        it "returns nil" do
          direction = [0, -1]
          translation = described_class.translate(starting, direction)
          expect(translation).to be_nil
        end
      end

      context "going one space south" do
        it "returns b8" do
          direction = [0, 1]
          translation = described_class.translate(starting, direction)
          expect(translation).to be "b8"
        end
      end

      context "going one space west" do
        it "returns nil" do
          direction = [-1, 0]
          translation = described_class.translate(starting, direction)
          expect(translation).to be_nil
        end
      end

      context "going one space east" do
        it "returns a7" do
          direction = [1, 0]
          translation = described_class.translate(starting, direction)
          expect(translation).to be "a7"
        end
      end

      context "going one space northwest" do
        it "returns nil" do
          direction = [-1, -1]
          translation = described_class.translate(starting, direction)
          expect(translation).to be_nil
        end
      end

      context "going one space southwest" do
        it "returns nil" do
          direction = [-1, 1]
          translation = described_class.translate(starting, direction)
          expect(translation).to be_nil
        end
      end

      context "going one space northeast" do
        it "returns nil" do
          direction = [1, -1]
          translation = described_class.translate(starting, direction)
          expect(translation).to be_nil
        end
      end

      context "going one space southeast" do
        it "returns b7" do
          direction = [1, 1]
          translation = described_class.translate(starting, direction)
          expect(translation).to be "b7"
        end
      end
    end
  end
end
