require "spec_helper"

describe Goggles::Iteration do
  it "yields an instantiated browser" do
    watir = instance_double "browser"
    expect(Watir::Browser).to receive(:new).and_return watir
    expect { |b| Goggles::Iteration.new "", "", "", &b }.to yield_with_args watir
  end
end
