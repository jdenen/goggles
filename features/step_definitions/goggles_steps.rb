Given /^I have configured Goggles with a valid directory$/ do
  @results = Pathname.new("./results").realdirpath.to_s 
  Goggles.configure { |c| c.directory = @results }
end

Given /^I have configured Goggles for browsers at (\d+) width$/ do |width| 
  Goggles.configure do |c|
    c.browsers = [:chrome, :firefox]
    c.sizes    = [width]
  end
end

When /^I extend configuration with arguments "(.*)"$/ do |args|
  @args = args.split(/,/).map(&:strip)
end

When /^I use "(.*)" to describe my screenshot of "(.*)"$/ do |desc, site|
  Goggles.each(@args) do |browser|
    browser.goto "http://#{site}"
    browser.grab_screenshot desc
  end
end

Then /^file "(.*)" exists$/ do |file|
  filepath = "#{@results}/#{file}"
  File.exists? filepath
end
