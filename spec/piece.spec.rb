require_relative "../lib/chess"

describe Chess::Piece do
  describe "#initialize" do
    context "after initializing as a white pawn" do
      subject(:white_pawn) { described_class.new(type: "pawn", color: "white") }

      it "has '♙' as its character" do
        character = white_pawn.character
        expect(character).to eq "♙"
      end
    end

    context "after initializing as a black pawn" do
      subject(:black_pawn) { described_class.new(type: "pawn", color: "black") }

      it "has '♟' as its character" do
        character = black_pawn.character
        expect(character).to eq "♟"
      end
    end

    context "after initializing as a white king" do
      subject(:white_king) { described_class.new(type: "king", color: "white") }

      it "has '♔' as its character" do
        character = white_king.character
        expect(character).to eq "♔"
      end
    end

    context "after initializing as a black queen" do
      subject(:black_queen) { described_class.new(type: "queen", color: "black") }

      it "has '♛' as its character" do
        character = black_queen.character
        expect(character).to eq "♛"
      end
    end
  end
end
