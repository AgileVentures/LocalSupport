Feature: I want to have a contact and about us link in all the app pages
  As the system owner
  So that I can be contacted
  I want to show a contact page and an about us page
  Tracker story ID: https://www.pivotaltracker.com/story/show/45693625

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
  Scenario Outline: the about us page is accessible on all pages
    Given I visit the <page>
    When I follow "About Us"
    Then I should see "abc123"
  Examples:
    | page                                                    |
    | home page                                               |
    | organisations index page                                |
    | new organisation page                                   |
    | show page for the organisation named "Friendly Charity" |

  Scenario Outline: the contact page is accessible on all pages
    Given I visit the <page>
    When I follow "Contact"
    Then I should see "def456"
  Examples:
    | page                                                    |
    | home page                                               |
    | organisations index page                                |
    | new organisation page                                   |
    | show page for the organisation named "Friendly Charity" |
