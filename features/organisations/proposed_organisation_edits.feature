Feature: Propose edits to organisation
  
  
  Background: organisations have been added to database

    Given the following organisations exist:
      | name                | description      | address        | postcode | website       | publish_address |
      | Elders Association  | For the elderly  | 64 pinner road | HA1 4HZ  | http://b.com/ | false           |
    
  
  Scenario: Users should not see organisation's non-published fields
    Given that I am logged in as any user
    When I visit "Elders Association" organisation page
    Then I should see "HA1 4HZ"
    And I should not see "64 pinner road"
    
  Scenario: Propose edits to another organisation as a regular user
    Given that I am logged in as any user
    And I visit "Elders Association" organisation propose edit page
    When I fill in "proposed_organisation_edit_description" with "Care for the elderly" within the main body
    And I fill in "proposed_organisation_edit_postcode" with "HA1" within the main body
    And I press "Propose this edit"
    Then I should see "Edit is pending admin approval."
    And I should see "Care for the elderly" within "proposed_organisation_description" field
    And I should see "HA1" within "proposed_organisation_postcode" field
