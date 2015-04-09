require "spec_helper"

describe Goggles::Iteration do
  let(:watir) { instance_double("browser") }

  before do
    allow(watir).to receive_messages(
                      :driver => watir,
                      :manage => watir,
                      :window => watir,
                      :goggles= => nil,
                      :iteration= => nil,
                      :resize_to => nil,
                      :close => nil)
  end

  it "yields an instantiated browser" do
    expect(Watir::Browser).to receive(:new).and_return watir
    expect { |b| Goggles::Iteration.new "", "", "", &b }.to yield_with_args watir
  end

  it "yields the browser based on the browser_name attribute" do
    expect(Watir::Browser).to receive(:new).with(:foo).and_return watir
    Goggles::Iteration.new(:foo, "", ""){ "bar" }
  end

  it "resizes the browser based on the size attribute" do
    expect(Watir::Browser).to receive(:new).with(:foo).and_return watir
    expect(watir).to receive(:resize_to).with(500, 768)
    Goggles::Iteration.new(:foo, 500, ""){ "bar" }
  end
end
