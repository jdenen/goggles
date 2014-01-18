# goggles

Goggles is a visual testing tool inspired by [wraith](http://github.com/bbc-news/wraith) and powered by [watir-webdriver](http://github.com/watir/watir-webdriver). It was created for a few itches wraith couldn't quite scratch:

* easy to integrate into your test suite
* configurable at a project level (as opposed to the gem level)
* scriptable in Ruby
* less Rake dependent

Choose your browsers and their sizes, what domain and paths to test, and any scripts to execute during those tests. Pass your choices through a config file, and let goggles do the rest.

## Installation

Install ImageMagick:

* OSX: `$ brew install imagemagick`
* Linux: `$ sudo apt-get install imagemagick`

Add this line to your application's Gemfile:

    gem 'goggles'

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install goggles

## Usage

Create a config file to point goggles in the right direction:
``` yaml
# config.yaml
results_directory: "/dir/where/you/output"

scripts_directory: "/dir/housing/scripts/to/be/executed"

scripts_to_execute:
  - "ruby_scripts.rb"
  - "you_want_to.rb"
  - "execute_as_part_of_testing.rb"

domain_under_test: "www.test-me.com"

paths_to_capture: 
  page_name: "/page/path"

browsers:
  - "chrome"
  - "firefox"

browser_widths:
  - 1024
  - 600
  - 320
  
image_fuzzing: "20%"
```

Create scripts to execute as part of your testing. Set cookies, use your page objects, take actions, etc. Goggles will always take a screenshot at the end of a script, but you can take extras as part of your scripting. Just pass a short description to the `#grab_screenshot` method. I've tried to keep variable names as unlikely to interrupt your code as possible, but `@watir` is reserved for the browser instance currently executing scripts.

``` ruby
# script_to_execute.rb
require 'goggles'

@watir.cookies.add("login_session", "encoded_login_information")

# Take screenshot for comparison with Goggles
Goggles.grab_screenshot("pre_button_click")

@watir.button(:id => "button-id").click
```

Finally, pass your config file path to goggles through the `#swim` method to kick the process off. Screenshots will be taken according to the scripts you've specified via configuration, and diff'd screenshots will be generated. The method will also return a hash with each comparison key pointing to relevant diff data (useful for determining pass/fail).

``` ruby
Goggles.swim("path/to/config.yml")
```

## Contributing

1. Fork it ( http://github.com/jdenen/goggles/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
