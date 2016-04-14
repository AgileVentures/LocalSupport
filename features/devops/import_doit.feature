@vcr
Feature: Importing DoIt Volunteer Ops
  As a technical administrator
  I would like to import doit ops into the database
  So that they can be displayed to the user

  Scenario: Check 3 miles
    Given I run the import doit service with a radius of 3 miles
    Then there should be 182 doit volunteer ops stored

  Scenario: Check import removes ops that are no longer on doit
    Given there is a doit volunteer op named "no longer on doit"
    And I run the import doit service with a radius of 0.5 miles
    Then the doit volunteer op named "no longer on doit" should be deleted
