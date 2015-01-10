Feature: Members of HCN may proposed edits to organisations
As a member of Harrow Community Network
So I can improve the accuracy of HCN
I want to be able to propose edits to inaccurate organisation listings

  Background: organisations have been added to database
    Given the following organisations exist:
      | name       | description             | address        | postcode | telephone | website             | email             | publish_phone |
      | Friendly   | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | admin@friendly.xx | true          |
    Given the following users are registered:
      | email                         | password | organisation | confirmed_at         | admin |
      | registered_user-2@example.com | pppppppp |              | 2007-01-01  10:00:00 | false |
      | admin@harrowcn.org.uk         | pppppppp |              | 2007-01-01  10:00:00 | true  |
      | friendly@friendly.org         | pppppppp | Friendly     | 2007-01-01  10:00:00 | false |
    And cookies are approved

  Scenario: Site admin does not see proposed edit button
    Given I am signed in as a admin
    And I visit the show page for the organisation named "Friendly"
    Then I should not see "Propose an edit"
    And I should see "Edit"

  Scenario: Org admin does not see proposed edit button
    Given I am signed in as a charity worker related to "Friendly"
    And I visit the show page for the organisation named "Friendly"
    Then I should not see "Propose an edit"
    And I should see "Edit"

  Scenario: See only published fields
    Given I am signed in as a charity worker unrelated to "Friendly"
    And I visit the show page for the organisation named "Friendly"
    Then I should see "Propose an edit"
    Then I click "Propose an edit"
    And I should be on the new organisation proposed edit page for the organisation named "Friendly"
    And the telephone field of the proposed edit should be pre-populated with the telephone of the organisation named "Friendly"
    And the address of the organisation named "Friendly" should not be editable nor appear

  Scenario: Propose an edit
    Given I am signed in as a charity worker unrelated to "Friendly"
    And I visit the show page for the organisation named "Friendly"
    And I click "Propose an edit"
    Then I should be on the new organisation proposed edit page for the organisation named "Friendly"
    When I propose the following edit:
      | name         | description            | website               |
      | Unfriendly   | Bereavement Counseling | http://unfriendly.org |
    And I press "Propose this edit"
    Then "Friendly" should have the following proposed edits:
      | name         | description            | website               |
      | Unfriendly   | Bereavement Counseling | http://unfriendly.org |
    Then I should be on the show organisation proposed edit page for the organisation named "Friendly"
    
