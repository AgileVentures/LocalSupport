@vcr
Feature: Importing DoIt Volunteer Ops
  As a technical administrator
  I would like to import doit ops into the database
  So that they can be displayed to the user

  Scenario: Check 3 miles
    Given I run the import doit service with a radius of 3 miles
    Then there should be 63 doit volunteer ops stored
    And all imported volunteer ops have latitude and longitude coordinates

  Scenario: Check import removes ops that are no longer on doit
    Given there is a doit volunteer op named "no longer on doit"
    And I run the import doit service with a radius of 0.5 miles
    Then the doit volunteer op named "no longer on doit" should be deleted

  Scenario: Does not import ops that are posted from LocalSupport
    Given there is a posted vol op with doit id "4d5f9b00-eaaa-45c4-adff-07707a9168b2"
    And I run the import doit service with a radius of 0.5 miles
    Then the doit volunteer op with id "4d5f9b00-eaaa-45c4-adff-07707a9168b2" should not be stored

  Scenario: Twitter response
    Given the date is "2018-02-10 00:00:00"
    Given the following volunteer opportunities exist:
      | title               | description                     | source | created_at          | updated_at          |
      | Litter Box Scooper  | Assist with feline sanitation   | doit   | 2018-02-09 17:17:33 | 2018-02-09 17:17:33 |
      | Litter Box Scooper 2| Assist with feline sanitation   | doit   | 2018-02-06 17:17:33 | 2018-02-06 17:17:33 |

    Then there should be 1 post to twitter
    When I run the update social media task
