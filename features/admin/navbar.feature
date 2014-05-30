Feature: Admin user interface
  As a site admin
  So that I can have a commanding view of important information
  I want a specialized interface

  Background:
    Given the following pages exist:
      | name         | permalink  | content |
      | About Us     | about      | abc123  |
    And the following users are registered:
      | email                 | password       | admin | confirmed_at        | organization | pending_organization |
      | admin@harrowcn.org.uk | mypassword1234 | true  | 2008-01-01 00:00:00 |              |                      |
    And I am signed in as a admin
    And I visit the home page

  Scenario Outline: Top navbar has an Admin dropdown menu
    Then the Admin menu has a valid <link> link
  Examples:
    | link                        |
    | Organisations Without Users |
    | Invited Users               |
    | All Users                   |

#  Scenario:  Highlighted button for Organisations or Volunteers
#    Given I visit the organisations index page
#    Then navbar button "Organisations" should be active
#    Then navbar button "Volunteers" should not be active
#
#    Given I visit the volunteer opportunities page
#    Then navbar button "Volunteers" should be active
#    Then navbar button "Organisations" should not be active
#
#    Given I visit "/pages"
#    Then navbar button "Volunteers" should not be active
#    Then navbar button "Organisations" should not be active
