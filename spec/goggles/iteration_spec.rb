require "spec_helper"

describe Goggles::Iteration do
  let(:watir) { instance_double("browser") }

  it "yields an instantiated browser" do
    expect(Watir::Browser).to receive(:new).and_return watir
    expect { |b| Goggles::Iteration.new "", "", "", &b }.to yield_with_args watir
  end

  it "yields the browser based on browser_name" do
    expect(Watir::Browser).to receive(:new).with(:foo).and_return watir
    Goggles::Iteration.new(:foo, "", ""){ "bar" }
  end
end
