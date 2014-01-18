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
      Then { images.size.should == 12 }
    end

    describe "generating diff images" do
      Then { diffs.size.should == 4 }
    end

    describe "generating diff data" do
      Then { datas.size.should == 4 }
    end
  end

  context "swimming against multiple paths without a script" do
    describe "taking screenshots" do
      Given(:scriptless_config) { "#{config_path}/test_config_scriptless.yml" }
      When { Goggles.swim(scriptless_config) }
      Then { images.size.should == 6 }
    end

    describe "generating diff images" do
      Then { diffs.size.should == 2 }
    end

    describe "generating diff data" do
      Then { datas.size.should == 2 }
    end
  end

end
