Feature: Org owner can edit volunteer opportunities
  As an org owner
  To keep my volunteer opportunities fresh
  I would like to be able to edit them
  https://www.pivotaltracker.com/story/show/73959288

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

    Given I am signed in as a charity worker related to "Cats Are Us"
    And I visit the show page for the volunteer_op titled "Litter Box Scooper"
    And I click "Edit"
    Then I should be on the edit page for the volunteer_op titled "Litter Box Scooper"

    Given I am signed in as a charity worker related to "Dogs Rule"
    And I visit the show page for the volunteer_op titled "Litter Box Scooper"
    And I should not see a link or button "Edit"
    And I visit the edit page for the volunteer_op titled "Litter Box Scooper"
    Then I should see "You must be signed in as an organisation owner or site superadmin to perform this action!"