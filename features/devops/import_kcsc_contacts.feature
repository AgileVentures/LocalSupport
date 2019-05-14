@vcr
Feature: Importing Organisations from KCSC
  As a technical administrator
  I would like to import organisations into the database
  So that they are kept up to date with latest KCSC records

  Scenario: Check KCSC Self Care Directory
    Given I run the import kcsc service
    Then there should be 179 organisations stored

  Scenario: handling existing charities (api imported)