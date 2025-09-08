require_relative "../lib/chess"

describe Chess::Board do
  subject(:board) { described_class.new }

  it "exists" do
    expect(board).to be_a Chess::Board
  end
end
