Feature: I want to have a contact and about us link in all the app pages
  As the system owner
  So that I can be contected
  I want to show a contact page and a about us page
  Tracker story ID: 45693625


Background: organizations have been added to database

  Given the following organizations exist:
  |name  | address |
  |Friendly Charity | 83 pinner road|


Scenario: the about us page is accesible from the charity search page
  Given I am on the charity search page
  When I follow "About Us"
  Then I should see "About Us"
  And I should see "The open source project Local Support is a directory of local charity and non-profit organisations for a small geographical area.  Our customer is the non-profit organization Voluntary Action Harrow.  The mission is to support members of the public searching for support groups for things like helping care for an elderly or sick relative; and also to help charities and non-profits find each other and network."

Scenario: the about us page is accesible from the charities page
  Given I am on the home page
  When I follow "About Us"
  Then I should see "About Us"
  And I should see "The open source project Local Support is a directory of local charity and non-profit organisations for a small geographical area.  Our customer is the non-profit organization Voluntary Action Harrow.  The mission is to support members of the public searching for support groups for things like helping care for an elderly or sick relative; and also to help charities and non-profits find each other and network."

Scenario: the about us page is accesible from the new charity page
  Given I am on the new charity page
  When I follow "About Us"
  Then I should see "About Us"
  And I should see "The open source project Local Support is a directory of local charity and non-profit organisations for a small geographical area.  Our customer is the non-profit organization Voluntary Action Harrow.  The mission is to support members of the public searching for support groups for things like helping care for an elderly or sick relative; and also to help charities and non-profits find each other and network."

 Scenario: the about us page is accesible from the edit charity page for "Friendly Charity"
  Given I am furtively on the edit charity page for "Friendly Charity"
  When I follow "About Us"
  Then I should see "About Us"
  And I should see "The open source project Local Support is a directory of local charity and non-profit organisations for a small geographical area.  Our customer is the non-profit organization Voluntary Action Harrow.  The mission is to support members of the public searching for support groups for things like helping care for an elderly or sick relative; and also to help charities and non-profits find each other and network."


Scenario: the about us page is accesible from the charity page
  Given I am on the charity page for "Friendly Charity"
  When I follow "About Us"
  Then I should see "About Us"
  And I should see "The open source project Local Support is a directory of local charity and non-profit organisations for a small geographical area.  Our customer is the non-profit organization Voluntary Action Harrow.  The mission is to support members of the public searching for support groups for things like helping care for an elderly or sick relative; and also to help charities and non-profits find each other and network."







Scenario: the contact page is accesible from the charity search page
  Given I am on the charity search page
  When I follow "Contact"
  Then I should see "Contact"
  And I should see "Samuel Joseph, PhD Email: tansaku@gmail.com Phone: Skype .tansaku.  Office: London, UK"

Scenario: the contact page is accesible from the charities page
  Given I am on the home page
  When I follow "Contact"
  Then I should see "Contact"
  And I should see "Samuel Joseph, PhD Email: tansaku@gmail.com Phone: Skype .tansaku.  Office: London, UK"

Scenario: the contact page is accesible from the new charity page
  Given I am on the new charity page
  When I follow "Contact"
  Then I should see "Contact"
  And I should see "Samuel Joseph, PhD Email: tansaku@gmail.com Phone: Skype .tansaku.  Office: London, UK"

 Scenario: the contact page is accesible from the edit charity page for "Friendly Charity"
  Given I am furtively on the edit charity page for "Friendly Charity"
  When I follow "Contact"
  Then I should see "Contact"
  And I should see "Samuel Joseph, PhD Email: tansaku@gmail.com Phone: Skype .tansaku.  Office: London, UK"


Scenario: the contact page is accesible from the charity page
  Given I am on the charity page for "Friendly Charity"
  When I follow "Contact"
  Then I should see "Contact"
  And I should see "Samuel Joseph, PhD Email: tansaku@gmail.com Phone: Skype .tansaku.  Office: London, UK"
