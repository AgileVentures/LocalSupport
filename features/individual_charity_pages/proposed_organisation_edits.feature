Feature: Members of HCN may proposed edits to organisations
As a member of Harrow Community Network
So I can improve the accuracy of HCN
I want to be able to propose edits to inaccurate organisation listings

  Background: organisations have been added to database
    Given the following organisations exist:
      | name              | description             | address        | postcode | telephone | website             | email             | publish_phone | publish_address | donation_info  |
      | Friendly          | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | superadmin@friendly.xx | true          |  false          | www.donate.com |
      | Really Friendly   | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | superadmin@friendly.xx | true          |  true           | www.donate.com |

    And the following organisations exist:
      | name              | description             | address        | postcode | telephone | email             | publish_phone | publish_address |
      | No website        | no website              | 30 pinner road |          | 020800000 | email@friendly.xx | true          |  true           |

    Given the following users are registered:
      | email                         | password | organisation        | confirmed_at         | superadmin |
      | registered_user-2@example.com | pppppppp |                     | 2007-01-01  10:00:00 | false |
      | superadmin@harrowcn.org.uk    | pppppppp |                     | 2007-01-01  10:00:00 | true  |
      | friendly@friendly.org         | pppppppp | Really Friendly     | 2007-01-01  10:00:00 | false |
    And cookies are approved

  @vcr
  Scenario: Site superadmin does not see proposed edit button
    Given I am signed in as a superadmin
    And I visit the show page for the organisation named "Really Friendly"
    Then I should not see "Propose an edit"
    And I should see "Edit"

  Scenario: Org superadmin does not see proposed edit button
    Given I am signed in as a charity worker related to "Really Friendly"
    And I visit the show page for the organisation named "Really Friendly"
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

  Scenario: Propose an edit with no website or donation info initially
    Given I visit the home page
    And I sign in as "registered_user-2@example.com" with password "pppppppp"
    And I visit the show page for the organisation named "No website"
    And I click "Propose an edit"
    When I propose the following edit:
      | website         | donation_info     | postcode |
      | www.newness.org | www.new.org/donate| HA1 4HZ  |
    And I press "Propose this edit"
    And "No website" should have the following proposed edits by user "registered_user-2@example.com":
      | website         | donation_info     | postcode |
      | www.newness.org | www.new.org/donate| HA1 4HZ  |
    Then I should be on the show organisation proposed edit page for the organisation named "No website"
    And an email should be sent to "superadmin@harrowcn.org.uk" as notification of the proposed edit to "No website"
    And the following proposed edits should be displayed on the page:
      | field                  | current value   | proposed value     |
      | donation_info          |                 | www.new.org/donate |
      | website                |                 | www.newness.org    |
      | postcode               |                 | HA1 4HZ            |

  Scenario: Propose an edit
    Given I visit the home page
    And I sign in as "registered_user-2@example.com" with password "pppppppp"
    And I visit the show page for the organisation named "Really Friendly"
    And I click "Propose an edit"
    Then I should be on the new organisation proposed edit page for the organisation named "Really Friendly"
    When I propose the following edit:
      | name         | description            | website               | email                      |  address         | postcode | telephone | donation_info  |
      | Unfriendly   | Mourning loved ones    | http://unfriendly.org | newemail@friendly.xx       |  124 Pinner Road | HA8 7TB  | 88888888  | www.pleasedonate.com |

    And I press "Propose this edit"
    And "Really Friendly" should have the following proposed edits by user "registered_user-2@example.com":
      | name         | description            | website               | email                      |  address         | postcode | telephone | donation_info         |
      | Unfriendly   | Mourning loved ones    | http://unfriendly.org | newemail@friendly.xx       |  124 Pinner Road | HA8 7TB  | 88888888  | www.pleasedonate.com  |
    Then I should be on the show organisation proposed edit page for the organisation named "Really Friendly"
    And an email should be sent to "superadmin@harrowcn.org.uk" as notification of the proposed edit to "Really Friendly"
    And I should see "This edit proposed by: registered_user-2@example.com"
    And the following proposed edits should be displayed on the page:
      | field         | current value                         | proposed value        |
      | name          | Really Friendly                       | Unfriendly            |
      | website       | http://friendly.org                   | http://unfriendly.org |
      | email         | superadmin@friendly.xx                | newemail@friendly.xx  |
      | description   | Bereavement Counselling               | Mourning loved ones   |
      | address       | 34 pinner road                        | 124 Pinner Road       |
      | postcode      | HA1 4HZ                               | HA8 7TB               |
      | telephone     | 020800000                             | 88888888              |
      | donation_info | http://www.donate.com                 | www.pleasedonate.com  |
    And I should not see a link or button "Accept Edit"
    And I should not see a link or button "Reject Edit"
