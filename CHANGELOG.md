# CHANGELOG

## v0.9.0 (Apr 14, 2015)
* `Goggles.each` accepts Array, Integer, String, and Symbol arguments.
* Arguments passed to `Goggles.each` extend configured settings instead of replacing them.
* Add Cucumber tests.

## v0.8.2 (Apr 10, 2015)
* Fix another typo in the gem description.

## v0.8.1 (Apr 10, 2015)
* Fix typo in gem description.

## v0.8.0 (Apr 10, 2015)
* Remove `swim` executable.
* Remove YAML configuration.
* Add `Goggles.configure` for configuration through a block (like RSpec).
* Remove reserved instance variables like `@gg_url`.
* Scripts are executed via blocks passed to `Goggles.each`. 
* `Goggles.each` yields a browser instance with the `#grab_screenshot` method.
* README updates.
* Add this CHANGELOG.

## v0.1.4 (Jan 28, 2014)
* Small code enhancements with no user impact.

## v0.1.3 (Jan 23, 2014)
* Do not delete cookies before each script.
* Make `@gg_url` variable available to scripts.

## v0.1.2 (Jan 21, 2014)
* Add diff color configuration setting.
* Default color setting to blue.
* Prepend all instance variables with `gg_`.

## v0.1.1 (Jan 20, 2014)
* Add command line option for generating default project

## v0.1.0 (Jan 20, 2014)
* Initial release
