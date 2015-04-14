Feature: Screenshot comparison
  As a software professional
  I want to automate the collection and comparison of screenshots on my application
  So I can efficiently assess visual regression

  Background:
    Given I have configured Goggles with a valid directory
    Given I have configured Goggles for browsers at 1080 width

  Scenario: Compare screenshots in two browsers at one size
    When I use the description "search-home" in my script
    Then I have a file called "search-home_1080/chrome_firefox_diff.png"
    And I have a file called "search-home_1080/chrome_firefox_data.txt"

  Scenario: Extending a script with more browsers and sizes
    When I extend configuration with arguments "phantomjs, 500"
    And I use the description "homepage" in my script
    Then I have a file called "homepage_1080/chrome_firefox_diff.png"
    And I have a file called "homepage_1080/chrome_firefox_data.txt"
    And I have a file called "homepage_1080/chrome_phantomjs_diff.png"
    And I have a file called "homepage_1080/chrome_phantomjs_data.txt"
    And I have a file called "homepage_1080/firefox_phantomjs_diff.png"
    And I have a file called "homepage_1080/firefox_phantomjs_data.txt"
