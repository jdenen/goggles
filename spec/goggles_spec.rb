require "spec_helper"

describe Goggles do
  before { allow(FileUtils).to receive(:mkdir_p) }
  
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
    let(:config) do
      Goggles.configure do |conf|
        conf.browsers = [:foo]
        conf.sizes    = [500]
      end
    end

    before do
      allow(config).to receive_messages(directory: "/dir", fuzzing: "20%", color: "blue", groups: [])
    end
    
    it "passes browser, width, and configuration to an iteration object" do
      expect(Goggles::Iteration).to receive(:new).with(:foo, 500, config)
      Goggles.each { "foo" }
    end

    context "when given a non-configured browser" do
      it "iterates with configured and argument browsers" do
        expect(Goggles::Iteration).to receive(:new).with(:foo, 500, config)
        expect(Goggles::Iteration).to receive(:new).with(:bar, 500, config)
        Goggles.each(:bar) { "foo" }
      end

      context "and given a non-configured size" do
        it "iterates over each configured and given combination" do
          [:foo, :bar].product([500, 1000]).each do |b, s|
            expect(Goggles::Iteration).to receive(:new).with(b, s, config)
          end
          Goggles.each(:bar, 1000) { "foo" }
        end
      end
    end
    
    it "returns a comparison object" do
      expect(Goggles::Iteration).to receive(:new).with(:foo, 500, config)
      expect(Goggles.each { "foo" }).to be_a Goggles::Comparison
    end

    context "when configured for browsers at one size" do
      it "creates an iteration for each browser with the width" do
        config.browsers << :bar
        [:foo, :bar].each { |browser| expect(Goggles::Iteration).to receive(:new).with browser, 500, config }
        Goggles.each { "foo" }
      end
    end

    context "when configured for browsers at different sizes" do
      it "creates an iteration for every browser and width combination" do
        config.browsers << :bar
        config.sizes << 1000

        [:foo, :bar].product([500, 1000]).each do |browser, width|
          expect(Goggles::Iteration).to receive(:new).with browser, width, Object
        end

        Goggles.each { "foo" }
      end
    end
  end
end
