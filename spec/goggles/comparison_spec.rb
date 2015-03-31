require "spec_helper"

describe Goggles::Comparison do
  let(:config){ instance_double "configuration" }
  let(:comparison){ Goggles::Comparison.new config }

  before do
    allow(config).to receive_messages(
                       directory: "dir",
                       fuzzing: "20%",
                       color: "blue",
                       groups: [1])
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
      expect(comparison).to receive(:groups).and_return [1, 2]
      expect(comparison).to receive(:find_comparable).with(1).and_return([])
      expect(comparison).to receive(:find_comparable).with(2).and_return([])
      comparison.cut_to_common_size
    end

    context "with collection of comparable screenshots" do
      it "iterates over the collection" do
        screens = instance_double "[screenshots]"
        expect(comparison).to receive(:groups).and_return ["foo"]
        expect(comparison).to receive(:find_comparable).and_return screens
        expect(screens).to receive(:each)
        expect(comparison).to receive(:cut!).with(screens, [])
        comparison.cut_to_common_size
      end
    end

    context "while iterating over collected comparable images" do
      it "opens each image in binary mode" do
        expect(comparison).to receive(:find_comparable).and_return [:foo]
        expect(File).to receive(:open).with(:foo, 'rb')
        expect(comparison).to receive(:cut!)
        comparison.cut_to_common_size
      end
    end
  end

  describe "#find_comparable" do
    it "returns an array of file paths" do
      array = ["/foo_chrome.png", "/bar_chrome.png", "/foo_ff.png", "/bar_ff.png"]
      expect(Dir).to receive(:glob).and_return array
      expect(comparison.find_comparable "foo").to eq ["/foo_chrome.png", "/foo_ff.png"]
    end
  end

  describe "#find_common_width" do
    it "returns the smallest number from first items in an array of arrays" do
      arrays = [[100,40], [68,300], [104,98]]
      expect(comparison.find_common_width arrays).to eq 68
    end
  end

  describe "#find_common_height" do
    it "returns the smallest number from second items in an array of arrays" do
      arrays = [[100,40], [68,300], [104,98]]
      expect(comparison.find_common_height arrays).to eq 40
    end
  end
end
