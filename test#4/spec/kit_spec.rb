require_relative "../kit"

describe Kit do
  describe "#day" do
    context "day's ago started" do
      it "returns an integer" do
        expect(Kit.new.day.class).to eq(Integer)
      end
    end
  end

  describe "#draggable?" do
    context "test if item is draggable" do
      it "returns false" do
        expect(Kit.new.draggable?).to eq(true)
      end
    end
  end

  describe "#title" do
    context "test type of computer" do
      it "returns macbook" do
        expect(Kit.new.title).to eq("MacBook")
      end
    end
  end
end
