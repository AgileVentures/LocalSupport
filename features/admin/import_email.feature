Feature: import email addresses
  As a Site Admin
  So that I enable contacting organizations
  I want to import emails for those organizations that do not have emails and not overwrite existing emails

Background: organizations have been added to database
  Given the following organizations exist:
    | name              | description              | address        | postcode | website       | email         |
    | I love dogs       | loves canines            | 34 pinner road | HA1 4HZ  | http://a.com/ | fred@dogs.com |
    | I love cats       | loves felines            | 64 pinner road | HA1 4HA  | http://b.com/ |               |
    | I hate animals    | hates birds and beasts   | 84 pinner road | HA1 4HF  | http://c.com/ |               |
  And a file exists:
    | Organisation      | Charity no. | Address 1 | Address 2 | Postcode | Phone | crb phoned | e-mail              |
    | I love dogs       |             |           |           |          |       |            | admin@dogs.com      |
    | I love Cats       |             |           |           |          |       |            | admin@cats.com      |
    | I hate animals    |             |           |           |          |       |            | admin@cruelty.com   |
    | I love people     |             |           |           |          |       |            | people@humanity.org |

  Scenario: import email addresses
    Given Google is indisposed for "64 pinner road"
    And I import emails from "db/email_test.csv"
    Then "I love dogs" should have email "fred@dogs.com"
    Then "I love cats" should have email "admin@cats.com"
    Then "I hate animals" should have email "admin@cruelty.com"
    And "I love cats" should not have nil coordinates

