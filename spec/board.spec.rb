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
      board_keys = board.all_squares.keys
      expect(board_keys).to contain_exactly(*expected_keys)
    end

    it "has immutable squares" do
      expect { board.all_squares["a3"] = "owo" }
        .not_to(change { board.all_squares })
    end
  end

  # there is one place for 2d coordinates and it is spatial translation,
  # because the pieces need some idea of "up", "down", "left", "right"...

  describe "#translate" do
    context "starting from a8" do
      starting = "a8"

      context "going one space north" do
        it "returns nil" do
          direction = [0, 1]
          translation = board.translate(starting, direction)
          expect(translation).to be_nil
        end
      end

      context "going one space south" do
        it "returns a7" do
          direction = [0, -1]
          translation = board.translate(starting, direction)
          expect(translation).to eq "a7"
        end
      end

      context "going one space west" do
        it "returns nil" do
          direction = [-1, 0]
          translation = board.translate(starting, direction)
          expect(translation).to be_nil
        end
      end

      context "going one space east" do
        it "returns b8" do
          direction = [1, 0]
          translation = board.translate(starting, direction)
          expect(translation).to eq "b8"
        end
      end

      context "going one space northwest" do
        it "returns nil" do
          direction = [-1, 1]
          translation = board.translate(starting, direction)
          expect(translation).to be_nil
        end
      end

      context "going one space southwest" do
        it "returns nil" do
          direction = [-1, -1]
          translation = board.translate(starting, direction)
          expect(translation).to be_nil
        end
      end

      context "going one space northeast" do
        it "returns nil" do
          direction = [1, 1]
          translation = board.translate(starting, direction)
          expect(translation).to be_nil
        end
      end

      context "going one space southeast" do
        it "returns b7" do
          direction = [1, -1]
          translation = board.translate(starting, direction)
          expect(translation).to eq "b7"
        end
      end
    end
  end

  # piece placement and movement is allowed to override existing pieces, as part of "capture".

  describe "#place_piece" do
    let(:white_pawn) { double("Piece", type: "pawn", color: :white, character: "♙") }
    let(:black_pawn) { double("Piece", type: "pawn", color: :black, character: "♟") }

    context "when placing a Piece at a2..." do
      placement = "a2"

      context "... and a2 is empty" do
        it "stores the Piece at key 'a3'" do
          expect { board.place_piece(white_pawn, placement) }
            .to change { board.at_square(placement) }
            .from(nil)
            .to(white_pawn)
        end
      end

      context "... and a2 has a Piece" do
        before { board.place_piece(black_pawn, placement) }

        it "stores the Piece at key 'a3', overriding the Piece already there" do
          expect { board.place_piece(white_pawn, placement) }
            .to change { board.at_square(placement) }
            .from(black_pawn)
            .to(white_pawn)
        end
      end
    end

    context "when placing a Piece out-of-bounds" do
      placement = "a10"

      it "does nothing to the board" do
        expect { board.place_piece(white_pawn, placement) }
          .not_to(change { board.all_squares })
      end
    end
  end

  describe "#move_piece" do
    let(:white_pawn) { double("Piece", type: "pawn", color: :white, character: "♙") }
    let(:black_pawn) { double("Piece", type: "pawn", color: :black, character: "♟") }

    context "when moving a Piece from a2..." do
      starting = "a2"
      context "... to a3, and a2 is empty" do
        ending = "a3"
        before { board.place_piece(black_pawn, ending) }

        it "does nothing" do
          expect { board.move_piece(starting, ending) }
            .not_to(change { [board.at_square(starting), board.at_square(ending)] })
        end
      end

      context "... to a3, and a3 is empty" do
        ending = "a3"
        before { board.place_piece(white_pawn, starting) }

        it "stores the Piece at key 'a3' and removes it from key 'a2'" do
          expect { board.move_piece(starting, ending) }
            .to(change { [board.at_square(starting), board.at_square(ending)] }
            .from([white_pawn, nil])
            .to([nil, white_pawn]))
        end
      end

      context "... to a3, and a3 has a Piece" do
        ending = "a3"
        before { board.place_piece(white_pawn, starting) }
        before { board.place_piece(black_pawn, ending) }

        it "stores the Piece at key 'a3', overriding the Piece already there, and removes it from key 'a2'" do
          expect { board.move_piece(starting, ending) }
            .to(change { [board.at_square(starting), board.at_square(ending)] }
            .from([white_pawn, black_pawn])
            .to([nil, white_pawn]))
        end
      end

      context "... to an out-of-bounds spot" do
        ending = "a10"
        before { board.place_piece(white_pawn, starting) }

        it "does nothing" do
          expect { board.move_piece(starting, ending) }
            .not_to(change { [board.at_square(starting), board.at_square(ending)] })
        end
      end
    end

    context "when moving from an out-of-bounds spot" do
      starting = "a10"
      ending = "a3"
      before { board.place_piece(black_pawn, ending) }

      it "does nothing to the board" do
        expect { board.move_piece(starting, ending) }
          .not_to(change { board.all_squares })
      end
    end
  end
end
