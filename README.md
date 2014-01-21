# goggles
[![Gem Version](https://badge.fury.io/rb/goggles.png)](http://badge.fury.io/rb/goggles)

Goggles is a visual testing tool inspired by [wraith](http://github.com/bbc-news/wraith) and powered by [watir-webdriver](http://github.com/watir/watir-webdriver). It allows you to compare screenshots of your web application in different browsers, and you can execute Ruby scripts to setup as many screenshots as you need.

## Installation

Install ImageMagick:

* OSX: `$ brew install imagemagick`
* Linux: `$ sudo apt-get install imagemagick`
* Windows: [Download](http://www.imagemagick.org/script/binary-releases.php#windows) installer and add to your PATH.

Add this line to your application's Gemfile:

    gem 'goggles'

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install goggles

## Usage

Generate a config file with `swim --init` to point goggles in the right direction.

    $ swim -i /home/configs/config.yaml

``` yaml
# config.yaml
# Directory where you want to store your results. Required.
results_directory: "/home/example/results"

# Directory where you're storing your scripts. Optional.
scripts_directory: "/home/example/scripts"

# Scripts to execute in the scripts directory. Optional.
scripts_to_execute:
  - "first_script.rb"
  - "second_script.rb"

# Domain to test. Required.
domain_under_test: "http://www.google.com"

# Paths to pages you want to test. Label them with a page name. Required.
paths_to_capture: 
  home: "/"
  gmail: "/gmail"

# Browsers you want to compare. Cannot specify more than two (yet). Required.
browsers:
  - "chrome"
  - "firefox"

# Widths at which you would like screenshots compared. All screenshots will be taken at a height of 768. Required.
browser_widths:
  - 1024

# Fuzzing percentage. Play around with this to find the right fit. Required.
image_fuzzing: "20%"
```

If you pass scripts to goggles as part of your testing, you **must** specify when screenshots should be taken with the `#grab_screenshot` method. If you do not specify scripts in configuration, goggles will open each of your paths and take a screenshot.

NOTE: I've tried to keep variable names as unlikely to interrupt your code as possible, but `@watir` is reserved for the browser instance currently executing scripts.

``` ruby
# script_to_execute.rb
require 'goggles'
@watir.cookies.add("cookie_name", "cookie_value")

# Pass a short description to the method for naming the resultant screenshot
Goggles.grab_screenshot("with_cookie_set")
```

Execute a goggles test through the command line with `swim --config CONFIG_FILE` or use `swim --help` to see command options.

    $ swim -c config.yml

## Contributing

1. Fork it ( http://github.com/jdenen/goggles/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Code until specs pass (`rspec`)*
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

\*Chrome and [ChromeDriver](http://code.google.com/p/selenium/wiki/ChromeDriver) are required to pass specs. Download the latest version and add it to your PATH before running `rspec`.

## Questions, Comments, Concerns
Easiest place to reach me is Twitter, [@jpdenen](http://twitter.com/jpdenen)
