Feature: Would like the site to appear high in Google's listing
         when one searches for harrow volunteering
    As a Site Super Admin
    So that I rank high on Google so people can find us
    I want the site to have the correct meta-tags

    Scenario: Meta Title and Description for SEO
      Given I visit the organisations index page
      Then I should have a page with a title: "Harrow Community Network"
      And I should see "Harrow Community Network is a nonprofit workers"
