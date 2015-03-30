require "spec_helper"

describe Goggles::Comparison do
  let(:config){ instance_double "configuration" }
  let(:comparison){ Goggles::Comparison.new config }

  before do
    allow(config).to receive_messages(
                       directory: "dir",
                       fuzzing: "20%",
                       color: "blue",
                       groups: [1, 2])
  end

  it "reads attributes from a given configuration object" do
    expect(config).to receive(:directory)
    expect(config).to receive(:fuzzing)
    expect(config).to receive(:color)
    Goggles::Comparison.new config
  end
  
  describe "#make_comparison" do
    it "cuts images and highlights their differences" do
      expect(comparison).to receive(:cut_to_common_size)
      expect(comparison).to receive(:highlight_differences)
      comparison.make_comparison
    end
  end

  describe "#cut_to_common_size" do
    it "iterates over screenshot descriptions" do
      groups = instance_double "[groups]"
      expect(comparison).to receive(:groups).and_return groups
      expect(groups).to receive(:each_with_object).with([])
      comparison.cut_to_common_size
    end

    it "collects comparable screenshots" do
      expect(comparison).to receive(:find_comparable).with(1)
      expect(comparison).to receive(:find_comparable).with(2)
      comparison.cut_to_common_size
    end
  end
end
