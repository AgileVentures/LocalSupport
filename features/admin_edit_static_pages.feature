Feature: I want to be able to edit static pages
  As a site admin
  So that I can update my website
  I want to be able to edit static pages
  Tracker story ID: https://www.pivotaltracker.com/story/show/52536437

  Background: organizations have been added to database
    Given the following pages exist:
      | name         | permalink  | content |
      | About Us     | about      | abc123  |
    And the following users are registered:
      | email                         | password | admin | confirmed_at         | organization |
      | registered-user-1@example.com | pppppppp | true  | 2007-01-01  10:00:00 | Friendly     |
      | registered-user-2@example.com | pppppppp | false | 2007-01-01  10:00:00 |              |

  Scenario: Admin can edit
    Given I am signed in as a admin
    And I am on the home page
    When I follow "About Us"
    Then I should see a link with text "edit"

  Scenario: Non-admin cannot edit
    Given I am signed in as a non-admin
    And I am on the home page
    When I follow "About Us"
    Then I should not see a link with text "edit"

  Scenario:
    Given I am on the edit page with the "about" permalink
    And I fill in "name" with "new name"
    And I fill in "permalink" with "new_link"
    And I fill in "content" with "xyz789"
    And I press "update"
    Then I should see "new name"
    And the URL should contain "new_link"
    And I should see "xyz789"
