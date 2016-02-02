Feature: Super Admin can edit volunteer opportunites
  As a site superadmin
  I would like to edit volunteer opportunities
  so that I can correct errors made by site users.
  https://www.pivotaltracker.com/story/show/73959288

Background:
    Given the following organisations exist:
      | name         | description     | address        | postcode |
      | Cats Are Us  | Animal Shelter  | 34 pinner road | HA1 4HZ  |
    And the following users are registered:
      | email                         | password | organisation | confirmed_at        | superadmin |
      | superadmin@harrowcn.org.uk         | pppppppp |              | 2007-01-01 10:00:00 | true  |
      | registered-user-2@example.com | pppppppp |              | 2007-01-01 10:00:00 | false |
    And the following volunteer opportunities exist:
      | title              | description                     | organisation              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |

@vcr
Scenario:
  Given I am signed in as a superadmin
  When I visit the show page for the volunteer_op titled "Litter Box Scooper"
  Then I should see an edit button for "Litter Box Scooper" volunteer opportunity

Scenario:
  Given I am signed in as a non-superadmin
  When I visit the show page for the volunteer_op titled "Litter Box Scooper"
  Then I should not see an edit button for "Litter Box Scooper" volunteer opportunity

Scenario:
  # Not logged in
  When I visit the show page for the volunteer_op titled "Litter Box Scooper"
  Then I should not see an edit button for "Litter Box Scooper" volunteer opportunity

Scenario: Super Admin successfully changes the description of an opportunity
  Given I am signed in as a superadmin
  When I update "Litter Box Scooper" volunteer op description to be "Clean up cat mess"
  Then I should see "Clean up cat mess"
