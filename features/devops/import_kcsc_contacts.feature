@vcr
Feature: Importing Organisations from KCSC
  As a technical administrator
  I would like to import organisations into the database
  So that they are kept up to date with latest KCSC records

  Scenario: Check KCSC Self Care Directory
    Given I run the import kcsc service
    Then there should be 179 organisations stored

  Scenario: handling existing charities (api imported)
    Given the following organisations exist:
      | name                        | imported_id | address        | postcode | website       |
      | Acquired Brain Injury (ABI) | 85344       | 34 pinner road | HA1 4HZ  | http://a.com/ |
    And I run the import kcsc service  
    When I visit the show page for the organisation named "Acquired Brain Injury (ABI)"
    Then I should not see "HA1 4HZ"
    And I should see "W1G 0AN"
    # And I debug