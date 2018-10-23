@vcr
Feature: Importing Organisations from Charity Commission
  As a technical administrator
  I would like to import organisations into the database
  So that they are kept up to date with latest charity commission records

  Scenario: Check Harrow Postcode
    Given I run the import organisation service
    Then there should be 50 organisations stored

  Scenario: handling existing charities (api imported)