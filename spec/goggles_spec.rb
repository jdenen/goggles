require "spec_helper"

describe Goggles do
  describe "#config" do
    it "yields a configuration object" do
      expect { |b| Goggles.configure &b }.to yield_with_args Goggles::Configuration
    end
  end
end
