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
      | email                      | password | organization | confirmed_at        | admin |
      | admin@harrowcn.org.uk      | pppppppp |              | 2007-01-01 10:00:00 | true  |
    And the following volunteer opportunities exist:
      | title              | description                     | organization              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |

Scenario:
  When I visit the show page for the volunteer_op titled "Litter Box Scooper"
  Then I should see an edit button for "Litter Box Scooper" volunteer opportunity

  # Unimplemented scenarios : Non-admin cannot see edit button, guest cannot see edit button
