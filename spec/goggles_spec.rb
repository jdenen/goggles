require "spec_helper"

describe Goggles do
  Given(:config_path) { "./spec/support/configs" }
  Given(:images) { Dir.glob("./spec/support/results/*/*.png") }
  Given(:diffs) { Dir.glob("./spec/support/results/*/*diff.png") }
  Given(:datas) { Dir.glob("./spec/support/results/*/*data.txt") }

  context "swimming with one script at multiple sizes" do
    describe "taking screenshots" do
      Given(:sizes_config) { "#{config_path}/test_config_1024_600.yml" }
      When { Goggles.swim(sizes_config) }
      Then { images.size.should == 6 }
      And { diffs.size.should == 2 }
      And { datas.size.should == 2 }
    end

    describe "generating error" do
      Given(:no_shot_config) { "#{config_path}/test_config_no_screenshot.yml" }
      Then { expect{ Goggles.swim(no_shot_config) }.to raise_error(Goggles::EmptyResultError) }
    end
  end

  context "swimming against multiple paths with no scripts" do
    describe "taking screenshots when commanded" do
      Given(:scriptless_config) { "#{config_path}/test_config_scriptless.yml" }
      When { Goggles.swim(scriptless_config) }
      Then { images.size.should == 6 }
      And { diffs.size.should == 2 }
      And { datas.size.should == 2 }
    end
  end

end
