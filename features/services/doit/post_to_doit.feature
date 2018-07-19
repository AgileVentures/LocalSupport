Feature: Post to doit
  As an organisation superadmin
  So that I can provide wider visibility for volunteer ops
  I want to post to doit

  Background:
    Given the following organisations exist:
      | name     | description             | address        | postcode | telephone | website                     | email                           |
      | Friendly | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.example.org | superadmin@friendly.example.org |
      | Shy      | Software design         | 34 pinner road | HA1 4HZ  | 020800001 | http://shy.example.org      | superadmin@shy.example.org      |

    And the following users are registered:
      | email                           | password | organisation | confirmed_at        | superadmin |
      | friend@harrowcn.org.uk          | pppppppp |              | 2007-01-01 10:00:00 | false      |
      | superadmin@friendly.example.org | pppppppp | Friendly     | 2007-01-01 10:00:00 | false      |
      | superadmin@shy.example.org      | pppppppp | Shy          | 2007-01-01 10:00:00 | false      |
      | superadmin@harrowcn.org.uk      | pppppppp | Shy          | 2007-01-01 10:00:00 | true       |
    And that the volunteer_ops_create flag is enabled
    And cookies are approved

  Scenario: Cannot post to doit with an arbitrary string for the start/end dates
    Given I am signed in as a superadmin
    And I submit a volunteer op with an arbitrary date on the "Friendly" page
    Then I should see "Advertise start date is invalid" and "Advertise end date is invalid"
