Feature: Super Admin user interface
  As a site superadmin
  So that I can have a commanding view of important information
  I want a specialized interface

  Background:
    Given the following pages exist:
      | name         | permalink  | content |
      | About Us     | about      | abc123  |
    And the following users are registered:
      | email                 | password       | superadmin | confirmed_at        | organisation | pending_organisation |
      | superadmin@harrowcn.org.uk | mypassword1234 | true  | 2008-01-01 00:00:00 |              |                      |
    And the invitation instructions mail template exists
    And I am signed in as a superadmin
    And that the volunteer_ops_list flag is enabled
    And I visit the home page

  Scenario Outline: Top navbar has a SuperAdmin dropdown menu
    Then the SuperAdmin menu has a valid <link> link
  Examples:
    | link                                          |
    | Invite Users to become admin of Organisations |
    | Invited Users                                 |
    | Registered Users                              |

  Scenario:  Highlighted button for Organisations or Volunteers
    Given I visit the organisations index page
    Then navbar button "Organisations" should be active
    Then navbar button "Volunteers" should not be active

    Given I visit the volunteer opportunities page
    Then navbar button "Volunteers" should be active
    Then navbar button "Organisations" should not be active

    Given I visit "/pages"
    Then navbar button "Volunteers" should not be active
    Then navbar button "Organisations" should not be active
