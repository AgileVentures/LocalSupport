Feature: Disclaimer about not being able to guarantee accuracy of sites content and notice about being beta site
  As the system owner
  So that I can avoid any liability
  I want to show a disclaimer page
  Tracker story ID: 49757817

Background: organizations have been added to database

  Given the following organizations exist:
  |name  | address |
  |Friendly Charity | 83 pinner road|


Scenario: the disclaimer page is accesible from the charity search page
  Given I am on the charity search page
  When I follow "Disclaimer"
  Then I should see "Disclaimer"
  And I should see "Whilst Voluntary Action Harrow has made effort to ensure the information here is accurate and up to date we are reliant on the information provided by the different organisations. No guarantees for the accuracy of the information is made."

Scenario: the disclaimer page is accesible from the charities page
  Given I am on the home page
  When I follow "Disclaimer"
  Then I should see "Disclaimer"
  And I should see "Whilst Voluntary Action Harrow has made effort to ensure the information here is accurate and up to date we are reliant on the information provided by the different organisations. No guarantees for the accuracy of the information is made."

Scenario: the disclaimer page is accesible from the new charity page
  Given I am on the new charity page
  When I follow "Disclaimer"
  Then I should see "Disclaimer"
  And I should see "Whilst Voluntary Action Harrow has made effort to ensure the information here is accurate and up to date we are reliant on the information provided by the different organisations. No guarantees for the accuracy of the information is made."

Scenario: the disclaimer page is accesible from the edit charity page for "Friendly Charity"
  Given I am furtively on the edit charity page for "Friendly Charity"
  When I follow "Disclaimer"
  Then I should see "Disclaimer"
  And I should see "Whilst Voluntary Action Harrow has made effort to ensure the information here is accurate and up to date we are reliant on the information provided by the different organisations. No guarantees for the accuracy of the information is made."

Scenario: the disclaimer page is accesible from the charity page
  Given I am on the charity page for "Friendly Charity"
  When I follow "Disclaimer"
  Then I should see "Disclaimer"
  And I should see "Whilst Voluntary Action Harrow has made effort to ensure the information here is accurate and up to date we are reliant on the information provided by the different organisations. No guarantees for the accuracy of the information is made."
