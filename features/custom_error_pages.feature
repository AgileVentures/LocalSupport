Feature: I want to make error pages follow the general design of the site.
  As a site administrator
  So that site users are not alarmed when I enter an incorrect URL
  I want custom error pages, rendered in-line with the rest of the site
  Pivotal Tracker story:  https://www.pivotaltracker.com/story/show/60838900

Background:
  Given the following pages exist:
  | name     | permalink | content                                                  |
  | 404      | 404       | We're sorry, but we couldn't find the page you requested!|
  | About Us | about     | We are the coolest guys around!                          |

#@allow-rescue
Scenario: Show custom 404 page
  Given I visit "/666"
  And I should see "We're sorry, but we couldn't find the page you requested!"
  And I should see "Harrow Community Network"
  And I should see "Search for local voluntary and community organisations"

Scenario: Do not show custom 404 page
  Given I visit "/about"
  And I should see "We are the coolest guys around!"
  And I should see "Harrow Community Network"
  And I should see "Search for local voluntary and community organisations"