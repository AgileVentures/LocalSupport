Feature: Admin user interface
  As a site admin
  So that I can have a commanding view of important information
  I want a specialized interface

  Background:
    Given the following users are registered:
      | email | password | admin | confirmed_at | organization | pending_organization |
      | admin@harrowcn.org.uk | mypassword1234 | true | 2008-01-01 00:00:00 | | |
    And I am signed in as a admin
    And I am on the home page

  Scenario Outline: Top navbar has Organizations dropdown menus
    #Given I click "Organisations"
    When I click "Without Users"
    Then I should be on the without users page
  # other links omitted until implemented
    Then the Organizations menu has a dropdown menu with a <link> link
  Examples:
    | link |
    | Without Users |

  Scenario Outline: Top navbar has Users dropdown menus
    #Given I click "Users"
    When I click "All"
    Then I should be on the all users page
  # other links omitted until implemented
    Then the Users menu has a dropdown menu with a <link> link
  Examples:
    | link |
    | All |
