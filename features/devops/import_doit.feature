@vcr
Feature: Importing DoIt Volunteer Ops
  As a technical administrator
  I would like to import doit ops into the database
  So that they can be displayed to the user

  Scenario: Check 3 miles
    Given I run the import doit service with a radius of 3 miles
    Then there should be 182 doit volunteer ops stored