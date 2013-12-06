Feature: As a site administrator
  I want to be able to show all project members on a page

Background:
  Given the following contributors exist:
  | login  | avatar_url                    |  html_url                | contributions |
  | thomas | http://example.com/thomas.png | http://github.com/thomas | 10            |
  | john   | http://example.com/john.png   | http://github.com/john   | 10            |




  Given the following pages exist:
    | name     | permalink | content                                                  |
    | 404      | 404       | We're sorry, but we couldn't find the page you requested!|

Scenario: Display project contributors
  Given I am on the home page
  And I click "Contributors"
  Then I should be on the contributors page
  And I should see "Project Contributors"
  And I should see "tochman"
  And I should see "tansaku"


