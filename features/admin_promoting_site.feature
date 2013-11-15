Feature: Admin promoting site
  As a site administrator
  So that people recognize our brand
  I want to have the site name displayed prominently
  Tracker story ID: https://www.pivotaltracker.com/story/show/50372317

Background: 

  Scenario Outline: Be aware of site identity on all pages
    Given I am on the <page>
    Then I should see "Harrow Community Network"
    And I should see "Search for local voluntary and community organisations"
  Examples:
    | page                 |
    | home page            |
    | charity search page  |
    | new charity page     |

