Feature: targeted email addresses
  As a Site Admin
  So that I get greater participation by orgs at the site
  I want a CSV listing organizations with emails but without admins

  Background: organizations have been added to database
    Given the following users are registered:
      | email         | password | admin  | confirmed_at         |  organization |
      | fred@dogs.com | pppppppp | false  | 2007-01-01  10:00:00 |  I love dogs  |
    Given the following organizations exist:
      | name              | description              | address        | postcode | email          |
      | I love dogs       | loves canines            | 34 pinner road | HA1 4HZ  | admin@dogs.com |
      | I love cats       | loves felines            | 64 pinner road | HA1 4HA  | admin@cats.org |
      | I hate people     | hates Earthlings         | 11 pinner road | HA1 4HA  | admin@mars.gov |
      | I hate animals    | hates birds and beasts   | 84 pinner road | HA1 4HF  |                |

  Scenario: Rake task is run
    Given I run the "db:target_emails" rake task located at "tasks/target_emails"
    Then I should have the file "db/target_emails.csv"

  #TODO this feature should be expanded to be a button for a site admin to click to run the rake task
  #and download the CSV from the website.


