Feature: Screenshot comparison
  As a software professional
  I want to automate the collection and comparison of screenshots on my application
  So I can efficiently assess visual regression

  Background:
    Given I have configured Goggles with a valid directory
    Given I have configured Goggles for browsers at 1080 width

  Scenario: Compare screenshots in two browsers at one size
    When I use "repo" to describe my screenshot of "github.com/jdenen/goggles"
    Then file "repo_1080/chrome_firefox_diff.png" exists
    And file "repo_1080/chrome_firefox_data.txt" exists

  Scenario: Extending a script with more browsers and sizes
    When I extend configuration with arguments "phantomjs, 500"
    And I use "search" to describe my screenshot of "google.com"
    Then file "search_1080/chrome_firefox_diff.png" exists
    And file "search_1080/chrome_firefox_data.txt" exists
    And file "search_1080/chrome_phantomjs_diff.png" exists
    And file "search_1080/chrome_phantomjs_data.txt" exists
    And file "search_1080/firefox_phantomjs_diff.png" exists
    And file "search_1080/firefox_phantomjs_data.txt" exists
