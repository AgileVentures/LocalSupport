Feature: I want to be able to edit static pages
  As a site admin
  So that I can update my website
  I want to be able to edit static pages
  Tracker story ID: https://www.pivotaltracker.com/story/show/52536437

  Background: organizations have been added to database
    Given the following pages exist:
      | name         | permalink  | content |
      | About Us     | about      | abc123  |

  Scenario: Admin can edit
    Given I am signed in as a admin
    When I follow "About us"
    Then I should see "edit"

  Scenario: Non-admin cannot edit
    Given I am signed in as a non-admin
    When I follow "About us"
    Then I should not see "edit"

  Scenario:
    Given I am on the edit page for a static page
    And I fill in "name" with "new name"
    And I fill in "permalink" with "new_link"
    And I fill in "content" with "xyz789"
    And I press "update"
    Then I should see "xyz789"
