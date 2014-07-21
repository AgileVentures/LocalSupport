Feature: Admin deleting charity
  As a Admin
  So that I can ensure that defunct charities are removed
  I want to be able to delete charities
  Tracker Story ID: https://www.pivotaltracker.com/story/show/59553308

  Background: organizations have been added to database
    Given the following organizations exist:
      | name     | description             | address        | postcode | telephone |
      | Friendly | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 |
    And the following users are registered:
      | email                 | password | admin | confirmed_at         | organization |
      | admin@example.com     | pppppppp | true  | 2007-01-01  10:00:00 |              |
      | org-admin@example.com | pppppppp | false | 2007-01-01  10:00:00 | Friendly     |
      | user@example.com      | pppppppp | false | 2007-01-01  10:00:00 |              |
    And cookies are approved

  Scenario: Admin successfully deletes a charity   # scenario 'Admin successfully deletes a charity' do
    Given I am signed in as a admin
    And I visit the show page for the organization named "Friendly"
    And I click "Delete"
    Then the organization "Friendly" should be deleted
    And I should see "Deleted Friendly" in the flash
    And I should be on the organisations index page

  Scenario: Org admin cannot see delete button
    Given I am signed in as a non-admin
    And I visit the show page for the organization named "Friendly"
    And I should not see "Delete"

  Scenario: Non-admin cannot see delete button
    Given I am signed in as a non-admin
    And I visit the show page for the organization named "Friendly"
    And I should not see "Delete"

  Scenario: Public cannot see delete button
    Given I visit the show page for the organization named "Friendly"
    And I should not see "Delete"

  Scenario: Non-admin unsuccessfully attempts to delete a charity directly
    Given I am signed in as a non-admin
    And I delete "Friendly" charity
    Then I should be on the show page for the organization named "Friendly"
    And I should see permission denied


