Feature: Admin deleting charity
  As a Admin
  So that I can ensure that defunct charities are removed
  I want to be able to delete charities
  Tracker Story ID: https://www.pivotaltracker.com/story/show/59553308

  Background: organizations have been added to database
    Given the following organizations exist:
      | name           | description             | address        | postcode | telephone |
      | Friendly       | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 |
      | Friendly Clone | Quite Friendly!         | 30 pinner road | HA1 4HZ  | 020800010 |
    And the following users are registered:
      | email                         | password | admin | confirmed_at         | organization |
      | registered-user-1@example.com | pppppppp | true  | 2007-01-01  10:00:00 | Friendly     |
      | registered-user-2@example.com | pppppppp | false | 2007-01-01  10:00:00 |              |
    And cookies are approved

  Scenario: Admin successfully deletes a charity   # scenario 'Admin successfully deletes a charity' do
    Given I am signed in as a admin
    And I visit the show page for the organization named "Friendly"
    And I click "Delete"
    Then the organization "Friendly" should be deleted
    # message to user that action has happened (flash - change style on entire show page to indicate deletion)
    And I should see "Deleted Friendly" in the flash
    And I should be on the organisations index page

  #Scenario - check only admin can delete charities


  Scenario: Non-admin unsuccessfully attempts to delete a charity
    Given I am signed in as a non-admin
    And I delete "Friendly" charity
    Then I should be on the show page for the organization named "Friendly"
    And I should see permission denied


