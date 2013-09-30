Feature: I want to have a contact and about us link in all the app pages
  As the system owner
  So that I can be contacted
  I want to show a contact page and an about us page
  Tracker story ID: https://www.pivotaltracker.com/story/show/45693625

Background: organizations have been added to database
  Given the following organizations exist:
    | name             | address       |
    | Friendly Charity | 83 pinner road|
  Given the following pages exist:
    | name         | permalink  | content |
    | About Us     | about      | abc123  |
    | Contact Info | contact    | def456  |

Scenario: the about us page is accessible from the charity search page
  Given I am on the charity search page
  When I follow "About Us"
  Then I should see "abc123"

Scenario: the about us page is accessible from the charities page
  Given I am on the home page
  When I follow "About Us"
  Then I should see "abc123"

Scenario: the about us page is accessible from the new charity page
  Given I am on the new charity page
  When I follow "About Us"
  Then I should see "abc123"

Scenario: the about us page is accessible from the edit charity page for "Friendly Charity"
  Given I am furtively on the edit charity page for "Friendly Charity"
  When I follow "About Us"
  Then I should see "abc123"

Scenario: the about us page is accessible from the charity page
  Given I am on the charity page for "Friendly Charity"
  When I follow "About Us"
  Then I should see "abc123"

Scenario: the contact page is accessible from the charity search page
  Given I am on the charity search page
  When I follow "Contact"
  Then I should see "def456"

Scenario: the contact page is accessible from the charities page
  Given I am on the home page
  When I follow "Contact"
  Then I should see "def456"

Scenario: the contact page is accessible from the new charity page
  Given I am on the new charity page
  When I follow "Contact"
  Then I should see "def456"

 Scenario: the contact page is accessible from the edit charity page for "Friendly Charity"
  Given I am furtively on the edit charity page for "Friendly Charity"
   When I follow "Contact"
   Then I should see "def456"

Scenario: the contact page is accessible from the charity page
  Given I am on the charity page for "Friendly Charity"
  When I follow "Contact"
  Then I should see "def456"