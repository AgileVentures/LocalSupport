Feature: import email addresses
  As a Site Super Admin
  So that I enable contacting organisations
  I want to import emails for those organisations that do not have emails and not overwrite existing emails

Background: organisations have been added to database
  Given the following organisations exist:
    | name              | description              | address        | postcode | website       | email         |
    | I love dogs       | loves canines            | 34 pinner road | HA1 4HZ  | http://a.com/ | fred@dogs.com |
    | I love cats       | loves felines            | 64 pinner road | HA1 4HZ  | http://b.com/ |               |
    | I hate animals    | hates birds and beasts   | 84 pinner road | HA1 4HZ  | http://c.com/ |               |
  And a file exists:
    | Organisation      | Charity no. | Address 1 | Address 2 | Postcode | Phone | crb phoned | e-mail              |
    | I love dogs       |             |           |           |          |       |            | superadmin@dogs.com      |
    | I love Cats       |             |           |           |          |       |            | superadmin@cats.com      |
    | I hate animals    |             |           |           |          |       |            | superadmin@cruelty.com   |
    | I love people     |             |           |           |          |       |            | people@humanity.org |

  @vcr
  Scenario: import email addresses
    Given Google is indisposed for "64 pinner road, HA1 4HZ"
    And I import emails from "db/email_test.csv"
    Then "I love dogs" should have email "fred@dogs.com"
    Then "I love cats" should have email "superadmin@cats.com"
    Then "I hate animals" should have email "superadmin@cruelty.com"
    And "I love cats" should not have nil coordinates
