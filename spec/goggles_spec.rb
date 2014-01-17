require "spec_helper"

describe Goggles do
  Given(:config_path) { "./spec/support/configs" }
  Given(:images) { Dir.glob("./spec/support/results/*/*.png") }
  Given(:diffs) { Dir.glob("./spec/support/results/*/*diff.png") }

  context "Google search at 1024x768" do
    Given(:config) { "#{config_path}/test_config_1024.yml" }
    When { Goggles.swim(config) }
    Then { images.size.should == 6 }
    And { diffs.size.should == 2 }
  end

  context "Google search at 1024x768 and 600x768" do
    Given(:config) { "#{config_path}/test_config_1024_600.yml" }
    When { Goggles.swim(config) }
    Then { images.size.should == 12 }
    And { diffs.size.should == 4 }
  end
end
