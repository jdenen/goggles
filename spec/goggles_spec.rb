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

    context "when given a browser argument" do
      it "extends the configured browser list with the given browser" do
        expect(Goggles::Iteration).to receive(:new).with(:foo, 500, config)
        expect(Goggles::Iteration).to receive(:new).with(:bar, 500, config)
        Goggles.each(:bar) { "foo" }
      end
    end

    context "when given a size argument" do
      it "extends the configured size list with the given size" do
        expect(Goggles::Iteration).to receive(:new).with(:foo, 500, config)
        expect(Goggles::Iteration).to receive(:new).with(:foo, 250, config)
        Goggles.each(250) { "foo" }
      end      
    end

    context "when given multiple browser and size arguments" do
      it "extends the configuration with correctly" do
        [:foo, :bar, :baz].product([500, 1000, 250]).each do |b, s|
          expect(Goggles::Iteration).to receive(:new).with(b, s, config)
        end
        Goggles.each(:bar, :baz, 1000, 250) { "foo" }
      end

      context "in no particular order" do
        it "extends the configuration with the correct arguments" do
          [:foo, :bar, :baz].product([500, 1000, 250]).each do |b, s|
            expect(Goggles::Iteration).to receive(:new).with(b, s, config)
          end
          Goggles.each(1000, :bar, :baz, 250) { "foo" }
        end
      end
    end

    context "when given arguments in arrays" do
      it "extends the configuration correctly" do
        [:foo, :bar, :baz].product([500, 1000, 250]).each do |b, s|
          expect(Goggles::Iteration).to receive(:new).with(b, s, config)
        end
        Goggles.each([:bar, :baz], [250, 1000]) { "foo" }
      end
    end

    context "when given arguments of various classes" do
      it "extends the configuration correctly" do
        [:foo, :bar, :baz].product([500, 1000, 250]).each do |b, s|
          expect(Goggles::Iteration).to receive(:new).with(b, s, config)
        end
        Goggles.each([:bar, "baz"], 250, "1000") { "foo" }
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
