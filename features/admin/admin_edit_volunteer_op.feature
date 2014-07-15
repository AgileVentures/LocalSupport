Feature: Admin can edit volunteer opportunites
  As a site admin
  I would like to edit volunteer opportunities
  so that I can correct errors made by site users.
  https://www.pivotaltracker.com/story/show/73959288

Background:
    Given the following organizations exist:
      | name         | description     | address        | postcode |
      | Cats Are Us  | Animal Shelter  | 34 pinner road | HA1 4HZ  |
    And the following users are registered:
      | email                         | password | organization | confirmed_at        | admin |
      | admin@harrowcn.org.uk         | pppppppp |              | 2007-01-01 10:00:00 | true  |
      | registered-user-2@example.com | pppppppp |              | 2007-01-01 10:00:00 | false |

    And the following volunteer opportunities exist:
      | title              | description                     | organization              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |

Scenario:
  Given I am signed in as an admin
  When I visit the show page for the volunteer_op titled "Litter Box Scooper"
  Then I should see an edit button for "Litter Box Scooper" volunteer opportunity

Scenario:
  Given I am signed in as a non-admin
  When I visit the show page for the volunteer_op titled "Litter Box Scooper"
  Then I should not see an edit button for "Litter Box Scooper" volunteer opportunity

Scenario:
  # Not logged in
  When I visit the show page for the volunteer_op titled "Litter Box Scooper"
  Then I should not see an edit button for "Litter Box Scooper" volunteer opportunity

Scenario: Admin successfully changes the description of an opportunity
  Given I am signed in as a admin
  And I update "Litter Box Scooper" description to be "Clean up cat mess"
  Then the description for "Litter Box Scooper" should be "Clean up cat mess"
