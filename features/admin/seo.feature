Feature: Would like the site to appear high in Google's listing
  As a Site Super Admin
  So people can find us
  I want us to rank highly in Google's listings

  Scenario: Meta Title and Description for SEO
    Given I visit the organisations index page
    Then I should have a page with a title: "Harrow Community Network"
    And I should see "Harrow Community Network is a nonprofit workers"
