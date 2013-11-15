Feature: Admin editing charity
  As an Admin
  So that I can ensure that charity information (for someone else) is correct (including adding a new organisation)
  I want to be able to edit/delete/add any charity information
  Tracker Story ID: https://www.pivotaltracker.com/story/show/50368203

  Background: organizations have been added to database
    Given the following organizations exist:
      | name           | description             | address        | postcode | telephone |
      | Friendly       | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 |
      | Friendly Clone | Quite Friendly!         | 30 pinner road | HA1 4HZ  | 020800010 |
    And the following users are registered:
      | email             | password | admin | confirmed_at |  organization |
      | registered-user-1@example.com | pppppppp | true  | 2007-01-01  10:00:00 |  Friendly |
      | registered-user-2@example.com | pppppppp | false | 2007-01-01  10:00:00 |           |

  # needs a migration ...
  Scenario: Admin deletes a charity
    Given I am signed in as an admin
    And I am on the charity page for "Friendly Clone"
    And I press "Delete"
    Then I should not see "Friendly Clone"
    But "Friendly Clone" should be persisted for undo purposes

  Scenario: Admin successfully changes the address of a charity
    Given I am signed in as a admin
    And I update "Friendly" charity address to be "30 pinner road"
    Then the address for "Friendly" should be "30 pinner road"
#TODO Refactor into integration test that posts to update method
#  Scenario: Non-admin unsuccessfully attempts to change the address of a charity
#    Given I am signed in as a non-admin
#    And I furtively update "Friendly" charity address to be "30 pinner road"
#    Then I should see "You don't have permission"
#    And "Friendly" charity address is "34 pinner road"

  Scenario: Non-admin sees no permission error when visiting the edit form for charity
    Given I am signed in as a non-admin
    And I am furtively on the edit charity page for "Friendly"
    Then I should be on the charity page for "Friendly"
    And I should see permission denied

  Scenario: Unsuccessfully attempt to create charity without being signed-in
    # should this be checking for absence of link to the new org page?
    Given I am on the new charity page
    Then I should be on the sign in page

# beta version only allows admin to create new organization, currently
# we only show link to admin, and are waiting on proper enforcement feature
# TODO get scenario as following commented one

  #Scenario: Unsuccessfully attempt to create charity when signed-in as non-admin
    ## should this be checking for absence of link to the new org page?
    #Given I am signed in as a non-admin
    #Given I am on the new charity page
    #Then I should be on the sign in page

  Scenario: Successfully create charity while being signed-in as admin
    Given I am signed in as a admin
    And I have created a new organization
    Then I should see "Organization was successfully created."

  Scenario: non logged in user should not see new organization link
    Given I am on the home page
    Then I should not see a new organizations link

  Scenario: logged in non-admin user should not see new organization link
    Given I am signed in as a non-admin
    Given I am on the home page
    Then I should not see a new organizations link
   
  Scenario: Non-admin unsuccessfully attempts to delete a charity
    Given I am signed in as a non-admin
    And I delete "Friendly" charity
    Then I should be on the charity page for "Friendly"
    And I should see permission denied

  Scenario: Non-admin unsuccessfully attempts to create an organization
    Given I am signed in as a non-admin
    And I create "Unwanted" org
    Then I should be on the organizations index page
    Then I should see permission denied
    And I should not see "Organization was successfully created."
    And "Unwanted" org should not exist

