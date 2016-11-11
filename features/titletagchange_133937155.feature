Feature: I want to shorten the static part of the title to contain only "Harrow volunteering" instead of "Harrow Community Network | Harrow volunteering"
  As the system owner
  So that I can apply further SEO to my system
  I want to the static part of the title to contain only "Harrow volunteering"
  Tracker story ID: https://www.pivotaltracker.com/story/show/133937155

  Background: organisations have been added to database
    Given the following organisations exist:
      | name             | description    | address        | postcode |
      | Friendly Charity | Amazeballs     | 83 pinner road | HA1 4HZ  |
    Given the following pages exist:
      | name         | permalink | content                                                   | link_visible |
      | 404          | 404       | We're sorry, but we couldn't find the page you requested! | false        |
      | About Us     | about     | abc123                                                    | true         |
      | Contact Info | contact   | def456                                                    | true         |

  @vcr
  Scenario Outline: the title to contains only "Harrow volunteering" and not "Harrow Community Network"
    Given I visit the <page>
    Then I should see "Harrow volunteering" in the page title
    And I should not see "Harrow Community Network" in the page title
  Examples:
    | page                                                    |
    | home page                                               |
    | organisations index page                                |
    | new organisation page                                   |
    | show page for the organisation named "Friendly Charity" |