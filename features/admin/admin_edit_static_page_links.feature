Feature: I want to be able to edit static page links
  As a site admin
  So that I can maintain my website
  I want to be able to edit static page link position
  Tracker story ID: https://www.pivotaltracker.com/story/show/52536437

  Background: organizations have been added to database
    Given the following pages exist:
    | name         | permalink  | content |
    | About HCN     | about      | abc123  |
    And the following users are registered:
    | email                         | password | admin | confirmed_at         |  organization |
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
     Scenario: Having all pages show automatically
       And I am on the home page
       Then I should see "About HCN"
       And I should see "Contact Info"
