require "spec_helper"

describe Goggles::Configuration do
  let(:config) { Goggles::Configuration.new }

  it "has attributes by default" do
    expect(config).to have_attributes(
                        :browsers  => [],
                        :sizes     => [],
                        :groups    => [],
                        :directory => "",
                        :color     => "blue",
                        :fuzzing   => "20%"
                      )
  end

  it "has attributes that can be set" do
    config.browsers << "chrome"
    config.sizes << 100
    config.groups << "foo"
    config.color = "red"
    config.fuzzing = "10%"

    expect(config).to have_attributes(
                        :browsers  => ["chrome"],
                        :sizes     => [100],
                        :groups    => ["foo"],
                        :color     => "red",
                        :fuzzing   => "10%"
                      )
  end

  describe "#directory=" do
    it "ensures the directory exists" do
      expect(FileUtils).to receive(:mkdir_p).with "/foo/bar"
      config.directory = "/foo/bar"
      expect(config.directory).to eq "/foo/bar"
    end

    context "when attribute is empty" do
      it "does not create the directory" do
        expect(FileUtils).to_not receive(:mkdir_p)
        config.directory = ""
      end
    end
  end
end
