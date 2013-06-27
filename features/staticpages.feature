Feature: I want to have a contact and about us link in all the app pages
  As the system owner
  So that I can be contected
  I want to show a contact page and a about us page
  Tracker story ID: https://www.pivotaltracker.com/story/show/45693625


Background: organizations have been added to database

  Given the following organizations exist:
  | name             | address       |
  | Friendly Charity | 83 pinner road|


Scenario: the about us page is accesible from the charity search page
  Given I am on the charity search page
  When I follow "About Us"
  Then I should see "About Us Supporting groups in Harrow We are a not-for-profit workers co-operative who support people and not-for-profit organisations to make a difference in their local community by: Working with local people and groups to identify local needs and develop appropriate action. Providing a range of services that help organisations to succeed. Supporting and encouraging the growth of co-operative movement. How do we support? Find out here (VAH in a nutshell) What is a Workers Co-operative? A workers co-operative is a business owned and democratically controlled by their employee members using co-operative principles. They are an attractive and increasingly relevant alternative to traditional investor owned models of enterprise. (Click here for more details)"

Scenario: the about us page is accesible from the charities page
  Given I am on the home page
  When I follow "About Us"
  Then I should see "About Us Supporting groups in Harrow We are a not-for-profit workers co-operative who support people and not-for-profit organisations to make a difference in their local community by: Working with local people and groups to identify local needs and develop appropriate action. Providing a range of services that help organisations to succeed. Supporting and encouraging the growth of co-operative movement. How do we support? Find out here (VAH in a nutshell) What is a Workers Co-operative? A workers co-operative is a business owned and democratically controlled by their employee members using co-operative principles. They are an attractive and increasingly relevant alternative to traditional investor owned models of enterprise. (Click here for more details)"

Scenario: the about us page is accesible from the new charity page
  Given I am on the new charity page
  When I follow "About Us"
  Then I should see "About Us Supporting groups in Harrow We are a not-for-profit workers co-operative who support people and not-for-profit organisations to make a difference in their local community by: Working with local people and groups to identify local needs and develop appropriate action. Providing a range of services that help organisations to succeed. Supporting and encouraging the growth of co-operative movement. How do we support? Find out here (VAH in a nutshell) What is a Workers Co-operative? A workers co-operative is a business owned and democratically controlled by their employee members using co-operative principles. They are an attractive and increasingly relevant alternative to traditional investor owned models of enterprise. (Click here for more details)"

 Scenario: the about us page is accesible from the edit charity page for "Friendly Charity"
  Given I am furtively on the edit charity page for "Friendly Charity"
  When I follow "About Us"
  Then I should see "About Us Supporting groups in Harrow We are a not-for-profit workers co-operative who support people and not-for-profit organisations to make a difference in their local community by: Working with local people and groups to identify local needs and develop appropriate action. Providing a range of services that help organisations to succeed. Supporting and encouraging the growth of co-operative movement. How do we support? Find out here (VAH in a nutshell) What is a Workers Co-operative? A workers co-operative is a business owned and democratically controlled by their employee members using co-operative principles. They are an attractive and increasingly relevant alternative to traditional investor owned models of enterprise. (Click here for more details)"

Scenario: the about us page is accessible from the charity page
  Given I am on the charity page for "Friendly Charity"
  When I follow "About Us"
  Then I should see "About Us Supporting groups in Harrow We are a not-for-profit workers co-operative who support people and not-for-profit organisations to make a difference in their local community by: Working with local people and groups to identify local needs and develop appropriate action. Providing a range of services that help organisations to succeed. Supporting and encouraging the growth of co-operative movement. How do we support? Find out here (VAH in a nutshell) What is a Workers Co-operative? A workers co-operative is a business owned and democratically controlled by their employee members using co-operative principles. They are an attractive and increasingly relevant alternative to traditional investor owned models of enterprise. (Click here for more details)"


Scenario: the contact page is accessible from the charity search page
  Given I am on the charity search page
  When I follow "Contact"
  Then I should see "Contact Info Email us: contact@voluntaryactionharrow.org.uk Phone Us: 020 8861 5894 Write to Us: The Lodge, 64 Pinner Road, Harrow, Middlesex, HA1 4HZ Find Us: On Social Media (Click Here)"

Scenario: the contact page is accessible from the charities page
  Given I am on the home page
  When I follow "Contact"
  Then I should see "Contact Info Email us: contact@voluntaryactionharrow.org.uk Phone Us: 020 8861 5894 Write to Us: The Lodge, 64 Pinner Road, Harrow, Middlesex, HA1 4HZ Find Us: On Social Media (Click Here)"

Scenario: the contact page is accessible from the new charity page
  Given I am on the new charity page
  When I follow "Contact"
  Then I should see "Contact Info Email us: contact@voluntaryactionharrow.org.uk Phone Us: 020 8861 5894 Write to Us: The Lodge, 64 Pinner Road, Harrow, Middlesex, HA1 4HZ Find Us: On Social Media (Click Here)"

 Scenario: the contact page is accessible from the edit charity page for "Friendly Charity"
  Given I am furtively on the edit charity page for "Friendly Charity"
  When I follow "Contact"
  Then I should see "Contact Info Email us: contact@voluntaryactionharrow.org.uk Phone Us: 020 8861 5894 Write to Us: The Lodge, 64 Pinner Road, Harrow, Middlesex, HA1 4HZ Find Us: On Social Media (Click Here)"

Scenario: the contact page is accesible from the charity page
  Given I am on the charity page for "Friendly Charity"
  When I follow "Contact"
  Then I should see "Contact Info Email us: contact@voluntaryactionharrow.org.uk Phone Us: 020 8861 5894 Write to Us: The Lodge, 64 Pinner Road, Harrow, Middlesex, HA1 4HZ Find Us: On Social Media (Click Here)"
