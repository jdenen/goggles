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
    config.directory = "/bar"
    config.color = "red"
    config.fuzzing = "10%"

    expect(config).to have_attributes(
                        :browsers  => ["chrome"],
                        :sizes     => [100],
                        :groups    => ["foo"],
                        :directory => "/bar",
                        :color     => "red",
                        :fuzzing   => "10%"
                      )
  end
end
