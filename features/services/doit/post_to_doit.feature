Feature: Post to doit
  As an organisation superadmin
  So that I can provide wider visibility for volunteer ops
  I want to post to doit

  Background:
    Given the following organisations exist:
      | name     | description       | address        | postcode | telephone | website                     | email                           |
      | Friendly | Friendly services | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.example.org | superadmin@friendly.example.org |

    And the following users are registered:
      | email                           | password | organisation | confirmed_at        | superadmin |
      | superadmin@friendly.example.org | icancyou | Friendly     | 2007-01-01 10:00:00 | true       |
    And that the volunteer_ops_create flag is enabled
    And cookies are approved

  Scenario: Cannot post to doit with an arbitrary string for the start/end dates
    Given I am signed in as a superadmin
    And I submit a volunteer op with an arbitrary string
    Then I should see "Advertise start date is invalid" and "Advertise end date is invalid"

  Scenario: Cannot post to doit with an end date before the start date
    Given I am signed in as a superadmin
    And I submit a volunteer op with an end date before the start date
    Then I should see "Advertise end date is invalid"

  Scenario: Should post to doit with valid dates
    Given I am signed in as a superadmin
    And I submit a volunteer op with valid dates
    Then I should not see "Advertise start date is invalid" and "Advertise end date is invalid"
