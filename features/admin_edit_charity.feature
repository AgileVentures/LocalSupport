Feature: Admin editing charity
  As an Admin
  So that I can ensure that charity information is correct
  I want to be able to edit any charity information
  Tracker Story ID: https://www.pivotaltracker.com/story/show/50368203

  Background: organizations have been added to database
    Given the following organizations exist:
      | name           | description             | address        | postcode | telephone |
      | Friendly       | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 |
      | Friendly Clone | Quite Friendly!         | 30 pinner road | HA1 4HZ  | 020800010 |
    Given the following users are registered:
      | email             | password | admin |
      | jcodefx@gmail.com | pppppppp | true  |
      | tansaku@gmail.com | pppppppp | false |

  Scenario: Admin successfully changes the address of a charity
    Given I am signed in as the admin using password "pppppppp"
    #Given I am signed in as the admin
    Given I update "Friendly" charity address to be "30 pinner road"
    Then I am on the home page
    And the coordinates for "Friendly Clone" and "Friendly" should be the same

  Scenario: Non-admin unsuccessfully attempts to change the address of a charity
    Given I am not signed in as the admin using password "pppppppp"
    And I furtively update "Friendly" charity address to be "30 pinner road"
    Then I should see "You don't have permission"
    And "Friendly" charity address is "34 pinner road"

  Scenario: Unsuccessfully attempt to create charity without being signed-in
    Given I am on the new charity page
    Then I should be on the sign in page

# TODO establish if just anyone can create an organization
  Scenario: Successfully create charity while being signed-in
    Given I am signed in as the admin using password "pppppppp"
    Given I am on the new charity page
    And I fill in the new charity page validly
    And I press "Create Organization"
    Then I should see "Organization was successfully created."

