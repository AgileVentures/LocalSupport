Feature: Admin promoting site
  As a site administrator
  So that people recognize our brand
  I want to have the site name displayed prominently
Background: 

Scenario: Be aware of site identity
  Given I am on the home page
  Then I should see "Harrow Community Network"

Scenario: Unsuccessfully attempt to create charity without being signed-in
  Given I am on the new charity page
  Then I should be on the sign in page

Scenario: Successfully create charity while being signed-in
  Given that I am logged in as any user
  Given I am on the new charity page
  And I fill in the new charity page validly
  And I press "Create Organization"
  Then I should see "Organization was successfully created."
