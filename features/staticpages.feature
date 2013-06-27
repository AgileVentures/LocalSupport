Feature: I want to have a contact and about us link in all the app pages
  As the system owner
  So that I can be contacted
  I want to show a contact page and a about us page
  Tracker story ID: https://www.pivotaltracker.com/story/show/45693625

Background: organizations have been added to database

  Given the following organizations exist:
  | name             | address       |
  | Friendly Charity | 83 pinner road|

Scenario: the about us page is accesible from the charity search page
  Given I am on the charity search page
  Then the about us should be available

Scenario: the about us page is accesible from the charities page
  Given I am on the home page
  Then the about us should be available

Scenario: the about us page is accesible from the new charity page
  Given I am on the new charity page
  Then the about us should be available

Scenario: the about us page is accesible from the edit charity page for "Friendly Charity"
  Given I am furtively on the edit charity page for "Friendly Charity"
  Then the about us should be available

Scenario: the about us page is accessible from the charity page
  Given I am on the charity page for "Friendly Charity"
  Then the about us should be available

Scenario: the contact page is accessible from the charity search page
  Given I am on the charity search page
  Then the contact information should be available

Scenario: the contact page is accessible from the charities page
  Given I am on the home page
  Then the contact information should be available

Scenario: the contact page is accessible from the new charity page
  Given I am on the new charity page
  Then the contact information should be available

 Scenario: the contact page is accessible from the edit charity page for "Friendly Charity"
  Given I am furtively on the edit charity page for "Friendly Charity"
  Then the contact information should be available

Scenario: the contact page is accesible from the charity page
  Given I am on the charity page for "Friendly Charity"
  Then the contact information should be available
