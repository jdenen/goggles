# goggles
[![Gem Version](https://badge.fury.io/rb/goggles.png)](http://badge.fury.io/rb/goggles)
[![Build Status](https://travis-ci.org/jdenen/goggles.svg?branch=master)](https://travis-ci.org/jdenen/goggles)

Goggles is a visual testing tool inspired by [wraith](http://github.com/bbc-news/wraith) and powered by [watir-webdriver](http://github.com/watir/watir-webdriver). It compares screenshots of your web applications in different browsers at differents sizes.

## Usage

### Configuration

Configure Goggles with a block passed to the `Goggles.configure` method, which will yield a config object to your block for manipulation. The `directory` setting must be configured for Goggles to work. You'll also need to provide `browsers` and `sizes` that you'd like to compare, but those can be configured with the script.

The `fuzzing` and `color` attributes default to "blue" and "20%" respectively. 

```ruby
Goggles.configure do |config|
  config.directory = "/path/to/my/results"
  config.browsers  = [:chrome, :firefox, :phantomjs]
  config.sizes     = [1080, 600]
  config.color     = "red"
end
```

### Scripting

Your Scripts are passed to `Goggles.each` as blocks. Goggles will iterate over the block with each combination of browser/browser size configured, and the method will yield a browser object to your script block.

```ruby
Goggles.each do |browser|
  browser.goto "http://www.google.com"
  browser.text_field(id: "lst-ib").value = "Google"
end
```

#### Browsers and sizes

You can pass additional browsers or browser sizes to `Goggles.each` as arrays. These arguments extend your configuration for this instance's script block only.

```ruby
Goggles.configure do |c|
  c.directory = "/some/directory"
  c.browsers = [:chrome, :firefox]
  c.sizes = [1080]
end

Goggles.each(:phantomjs, 500) do |browser|
  # Script to be executed with Chrome, Firefox,
  # and PhantomJS at widths of 1080 and 500.
end

Goggles.each do |browser|
  # Script to be executed with Chrome and
  # Firefox at a width of 1080.
end
```

#### Screenshots

Your script blocks should include the `Watir::Browser#grab_screenshot` method, which has been patched onto the browser objects yielded to your blocks. Simply give the method a description argument and the screenshot will be saved to your configured directory.

```ruby
Goggles.each do |browser|
  browser.goto "http://www.google.com"
  browser.grab_screenshot "homepage"
end
```

#### Closing the browser

There's no need to explicitly close the browser objects in your script blocks. Goggles will handle that.

#### Results

Screenshots are saved to your configured directory. Screenshot comparison results are saved to a sub-folder based on the screenshot description and browser size. Results include a diff image and data file.

```ruby
Goggles.configure do |c|
  c.directory = "/goggles/results"
  c.browsers  = [:chrome, :firefox, :phantomjs]
  c.sizes     = [1080, 600]
end

Goggles.each do |browser|
  browser.goto "http://www.google.com"
  browser.grab_screenshot "google"
end
```


```
/goggles/results
 |- google_1080_chrome.png
 |- google_1080_firefox.png
 |- google_1080_phantomjs.png
 |- google_600_chrome.png
 |- google_600_firefox.png
 |- google_600_phantomjs.png
 |- /google_1080
     |- chrome_firefox_data.txt
     |- chrome_firefox_diff.png
     |- chrome_phantomjs_data.txt
     |- chrome_phantomjs_diff.png
     |- firefox_phantomjs_data.txt
     |- firefox_phantomjs_diff.png
 |- /google_600
     |- chrome_firefox_data.txt
     |- chrome_firefox_diff.png
     |- chrome_phantomjs_data.txt
     |- chrome_phantomjs_diff.png
     |- firefox_phantomjs_data.txt
     |- firefox_phantomjs_diff.png
```

## Installation

Install ImageMagick:

* OSX: `$ brew install imagemagick`
* Ubuntu: `$ sudo apt-get install imagemagick`
* Windows: [Download](http://www.imagemagick.org/script/binary-releases.php#windows) installer and add to your PATH.

Add this line to your application's Gemfile:

    gem 'goggles'

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install goggles

## Contributing

1. Fork it ( http://github.com/jdenen/goggles/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Questions, Comments, Concerns
Find me on Twitter ([@jpdenen](http://twitter.com/jpdenen)) or write up an issue.
