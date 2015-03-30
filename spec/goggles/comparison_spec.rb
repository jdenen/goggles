require "spec_helper"

describe Goggles::Comparison do
  let(:config){ instance_double "configuration" }
  let(:comparison){ Goggles::Comparison.new config }

  before do
    allow(config).to receive_messages(
                       directory: "dir",
                       fuzzing: "20%",
                       color: "blue")
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
end
