Feature: I want to make error pages follow the general design of the site.
  Pivotal Tracker story:  https://www.pivotaltracker.com/story/show/60838900
Background:
  Given the following pages exist:
  | name | permalink | content                                                  |
  | 404  | 404       | We're sorry, but we couldn't find the page you requested!|
  | About Us | about | We are the coolest guys around!                          |

#@allow-rescue
Scenario: Show custom 404 page
  Given I visit "/666"
  And I should see "We're sorry, but we couldn't find the page you requested!"

Scenario: Do not show custom 404 page
  Given I visit "/about"
  And I should see "We are the coolest guys around!"