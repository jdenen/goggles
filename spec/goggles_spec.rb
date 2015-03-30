require "spec_helper"

describe Goggles do
  describe "#config" do
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
end
