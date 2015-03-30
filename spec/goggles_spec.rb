require "spec_helper"

describe Goggles do
  describe ".configure" do
    it "yields a configuration object" do
      expect { |b| Goggles.configure &b }.to yield_with_args Goggles::Configuration
    end

    it "returns a configuration object" do
      expect(Goggles.configure { "foo" }).to be_a Goggles::Configuration
    end

    it "memoizes the configuration object" do
      expect(Goggles.configure { "foo" }).to equal Goggles.configure { "bar" }
    end
  end

  describe ".each" do
    let(:chrome){ double "chrome" }
    let(:firefox){ double "firefox" }
    
    it "passes browser, width, and configuration to an iteration object" do
      config = Goggles.configure do |conf|
        conf.browsers = [chrome]
        conf.sizes    = [500]
      end
      
      expect(Goggles::Iteration).to receive(:new).with(chrome, 500, config)
      Goggles.each { "foo" }
    end
    
    it "returns a comparison object" do
      expect(Goggles.each { "foo" }).to be_a Goggles::Comparison
    end

    context "when configured for browsers at one size" do
      it "creates an iteration for each browser with the width" do
        Goggles.configure do |conf|
          conf.browsers = [:foo, :bar]
          conf.sizes    = [500]
        end

        [:foo, :bar].each do |browser|
          expect(Goggles::Iteration).to receive(:new).with browser, 500, Object
        end

        Goggles.each { "foo" }
      end
    end

    context "when configured for browsers at different sizes" do
      it "creates an iteration for every browser and width combination" do
        Goggles.configure do |conf|
          conf.browsers = [:foo, :bar]
          conf.sizes    = [500, 1000]
        end

        [:foo, :bar].product([500, 1000]).each do |browser, width|
          expect(Goggles::Iteration).to receive(:new).with browser, width, Object
        end

        Goggles.each { "foo" }
      end
    end
  end
end
