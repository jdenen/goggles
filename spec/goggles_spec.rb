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
    it "yields browser and browser width" do
      chrome = double("chrome")
      width  = double("width")
      
      Goggles.configure do |config| 
        config.browser = chrome
        config.size    = width
      end
      
      expect { |b| Goggles.each &b }.to yield_with_args chrome, width
    end
    
    it "returns a comparison object" do
      expect(Goggles.each { "foo" }).to be_a Goggles::Comparison
    end
  end
end
