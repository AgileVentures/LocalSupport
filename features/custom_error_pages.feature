Feature: I want to make error pages follow the general design of the site.
  Pivotal Tracker story:  https://www.pivotaltracker.com/story/show/60838900

#@allow-rescue
Scenario: Show custom 404 page
  Given I try to access "222" page

  And the page should be titled "404 Page Not Found"
  And I should see "We're sorry, but we couldn't find the page you requested"