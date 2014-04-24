Feature: Pagination with Infinite Scrolling
  As an local resident
  So that I can see a list of all the organizations in a paginated form
  I want to be able to see 5 organizations at first and scroll down to see more
  Tracker Story ID: https://www.pivotaltracker.com/s/projects/742821/stories/51382275

@javascript
Scenario: Only 4 organizations are visible on the first page
  Given I have created 4 organizations
  And I visit the home page
  Then I should see a list of 4 organizations on the index page
  When I scroll down the organizations list
  Then I should see a list of 4 organizations on the index page

@javascript
Scenario: Scrolling down gives more scenarios
  Given I have created 11 organizations
  And I visit the home page
  Then I should see a list of 5 organizations on the index page
  When I scroll down the organizations list
  Then I should see a list of 10 organizations on the index page
  When I scroll down the organizations list
  Then I should see a list of 11 organizations on the index page

@javascript
Scenario: Searching gives results in a paginated form
  Given I have created 25 organizations
  And I visit the home page
  When I search for "e"
  Then I should see a list of 5 organizations on the search page with query "e"
  When I scroll down the organizations list
  Then I should see a list of 10 organizations on the search page with query "e"
