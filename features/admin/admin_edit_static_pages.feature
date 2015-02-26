Feature: I want to be able to edit static pages
  As a site superadmin
  So that I can update my website
  I want to be able to edit static pages via markdown
  Tracker story ID: https://www.pivotaltracker.com/story/show/52536437

  Background: organisations have been added to database
    Given the following pages exist:
      | name         | permalink  | content    | link_visible |
      | About Us     | about      | abc123     | true         |
      | Wow          | wow        | wow678     | true	      |
      | Bob          | bob        | bobcontent | true	      |
    And the following users are registered:
      | email                         | password | superadmin | confirmed_at         |  organisation |
      | registered-user-1@example.com | pppppppp | true  | 2007-01-01  10:00:00 |  Friendly     |
      | registered-user-2@example.com | pppppppp | false | 2007-01-01  10:00:00 |               |
    And cookies are approved
    And a static page named "Contact Info" with permalink "contact" and markdown content:
      """
      This is a *significant* word

      This is **important** text

      1.  Numbered list

      *  Bullet list

      ### This is an h3 header

      Here is a [link to relishapp](http://relishapp.com)
      and another link: www.relishapp.com

      This _message_ is important too.
      """

  Scenario: Super Admin can edit
    Given I am signed in as a superadmin
    And I visit the home page
    When I follow "About Us"
    Then I should see a link with text "Edit"
    And I follow "Edit"
    Then I should be on the edit page for "about"

  Scenario: Non-superadmin cannot edit
    Given I am signed in as a non-superadmin
    And I visit the home page
    When I follow "About Us"
    Then I should not see a link with text "Edit"

  Scenario: Super Admin can see pages index
    Given I am signed in as a superadmin
    And I visit the home page
    When I follow "About Us"
    And I follow "Pages"
    Then the URL should contain "pages"

  Scenario: Pages index is sorted by default
    Given I am signed in as a superadmin
    And I visit the home page
    When I follow "About Us"
    And I follow "Pages"
    Then I should see "Bob" page before "Wow"

  Scenario: Non-superadmin cannot see pages index
    Given I am signed in as a non-superadmin
    And I visit "/pages"
    Then I should see "You must be signed in as a superadmin to perform this action!"
    And I should be on the home page

  Scenario: Static pages are editable
    Given I am signed in as a superadmin
    And I am on the edit page with the "about" permalink
    And I fill in "page_name" with "new name" within the main body
    And I fill in "page_permalink" with "new_link" within the main body
    And I fill in "page_content" with "xyz789" within the main body
    And I press "Update Page"
    And the URL should contain "new_link"
    And I should see "xyz789"

  Scenario: Basic markdown syntax works
    Given I visit the home page
    When I follow "Contact"
    Then I should see "significant" < emphasized >
    And I should see "important" < stronged >
    And I should see "Numbered list" < number listed >
    And I should see "Bullet list" < bullet listed >
    And I should see "This is an h3 header" < tagged > with "h3"
    And I should see "link to relishapp" < linked > to "http://relishapp.com"
    And I should see "www.relishapp.com" < linked > to "http://www.relishapp.com"
    And I should see "message" < emphasized >



