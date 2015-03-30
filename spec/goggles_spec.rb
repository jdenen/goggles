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
    let(:width){ double "width" }

    before do
      Goggles.configure do |config| 
        config.browsers = [chrome]
        config.size     = width
      end
    end
    
    it "yields browser and browser width" do
      expect { |b| Goggles.each &b }.to yield_with_args chrome, width
    end
    
    it "returns a comparison object" do
      expect(Goggles.each { "foo" }).to be_a Goggles::Comparison
    end

    context "when configured for browsers at one size" do
      it "yields each browser with the width" do
        Goggles.configure { |config| config.browsers << firefox }
        expect{ |b| Goggles.each &b }.to yield_successive_args [chrome,width], [firefox,width]
      end
    end
  end
end
