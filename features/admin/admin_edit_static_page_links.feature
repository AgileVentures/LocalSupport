Feature: I want to be able to edit static page links
  As a site superadmin
  So that I can maintain my website
  I want to be able to edit static page link position
  Tracker story ID: https://www.pivotaltracker.com/story/show/52536437

  Background: organisations have been added to database
    Given the following pages exist:
    | name          | permalink  | content | link_visible |
    | About HCN     | about      | abc123  | true         |
    | Contact Info  | contact    | 123ccc  | false        |    

    And the following users are registered:
    | email                         | password | superadmin | confirmed_at         |  organisation |
    | registered-user-1@example.com | pppppppp | true  | 2007-01-01  10:00:00 |  Friendly     |
    | registered-user-2@example.com | pppppppp | false | 2007-01-01  10:00:00 |               |
    And cookies are approved

     Scenario: Having all pages show automatically
       And I visit the home page
       Then I should see "About HCN"
       And I should not see "Contact Info"

     Scenario: Super Admin can unlink and then link page, using its edit page
       Given I am signed in as a superadmin
       And I visit "pages/about/edit"
       And I uncheck "Show a public link to this page"
       And I press "Update Page"
       And I visit the home page
       Then the "about" link is not in the footer     
       And I visit "pages/about/edit"
       And I check "Show a public link to this page"
       And I press "Update Page"
       And I visit the home page
       Then the "about" link is in the footer     

