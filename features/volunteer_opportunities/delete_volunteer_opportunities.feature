Feature: Org owner can delete volunteer opportunities
  As an org owner
  So that I can ensure filled volunteer vacancies are not on the system
  I would like to be able to delete volunteer opportunities


  Background:
    Given the following organisations exist:
      | name         | description     | address        | postcode |
      | Cats Are Us  | Animal Shelter  | 34 pinner road | HA1 4HZ  |
      | Dogs Rule    | Dog lovers      | 34 pinner road | HA1 4HZ  |
    And the following users are registered:
      | email                         | password | organisation | confirmed_at        | superadmin |
      | registered-user-1@example.com | pppppppp | Cats Are Us  | 2007-01-01 10:00:00 | false |
      | dogs@example.com              | pppppppp | Dogs Rule    | 2007-01-01 10:00:00 | false |
    And the following volunteer opportunities exist:
      | title              | description                     | organisation              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |
      | Litter Box Scooper 2| Assist with feline sanitation   | Cats Are Us               |

    Given I am signed in as a charity worker related to "Cats Are Us"
    And I visit the show page for the volunteer_op titled "Litter Box Scooper"
    And I click "Delete"
    Then I should see "Deleted Litter Box Scooper" in the flash

    Given I am signed in as a charity worker related to "Dogs Rule"
    And I visit the show page for the volunteer_op titled "Litter Box Scooper 2"
    Then I should not see a link or button "Delete"
