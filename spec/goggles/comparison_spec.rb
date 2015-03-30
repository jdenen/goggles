require "spec_helper"

describe Goggles::Comparison do
  let(:comparison){ Goggles::Comparison.new }
  
  describe "#make_comparison" do
    it "cuts images and highlights their differences" do
      expect(comparison).to receive(:cut_to_common_size)
      expect(comparison).to receive(:highlight_differences)
      comparison.make_comparison
    end
  end
end
