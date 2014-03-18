Feature: As a site administrator
  I want to be able to show all project members on a page

Background:
  Given the following contributors exist:
  | login  | avatar_url                    | html_url                 | contributions |
  | thomas | http://example.com/thomas.png | http://github.com/thomas | 10            |
  | john   | http://example.com/john.png   | http://github.com/john   | 10            |

Scenario: Display project contributors
  Given I am on the home page
  And I follow the AgileVentures logo
  Then I should be on the contributors page
  And I should see "Project Contributors"
  And I should see "thomas"
  And I should see "john"

Scenario: Display avatar and links
  Given I am on the contributors page
  Then I should see a link avatar for "thomas"
  And I should see a link avatar for "john"



