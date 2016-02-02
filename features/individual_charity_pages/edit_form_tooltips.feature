Feature:  Tool tip instructions for fields on edit form
  As a charity owner
  So that I can fill out the edit form correctly
  I want to be able to have detailed tool tip instructions for edit form

  Tracker story ID: https://www.pivotaltracker.com/story/show/55198634

  Background:
    Given the following organisations exist:
      | name                            | description                      | address        | postcode | website       |
      | Harrow Bereavement Counselling  | Harrow Bereavement Counselling   | 34 pinner road | HA1 4HZ  | http://a.com/ |

    Given the following users are registered:
      | email                         | password | organisation                    | confirmed_at |
      | registered_user-3@example.com | pppppppp | Harrow Bereavement Counselling  | 2007-01-01  10:00:00 |
    And cookies are approved

  @vcr
  Scenario: Display tooltip for each field on the edit form
    Given I am signed in as a charity worker related to "Harrow Bereavement Counselling"
    And I visit the edit page for the organisation named "Harrow Bereavement Counselling"
    Then the following tooltips should exist:
      | label                                                     |  tooltip                                                                                                                                                                        |
      | Address                                                   |  Enter a complete address                                                                                                                                                       |
      | Add an additional organisation superadministrator email   |  Please enter the details of individuals from your organisation you would like to give permission to update your entry. E-mail addresses entered here will not be made public.  |
      | Name                                                      |  Enter a unique name                                                                                                                                                            |
      | Postcode                                                  |  Make sure post code is accurate                                                                                                                                                |
      | Email                                                     |  Make sure email is correct                                                                                                                                                     |
      | Description                                               |  Enter a full description here. When an individual searches this database all words in this description will be searched.                                                       |
      | Website                                                   |  Make sure url is correct                                                                                                                                                       |
      | Telephone                                                 |  Make sure phone number is correct                                                                                                                                              |
      | Donation                                                  |  Please enter a website here either to the fundraising page on your website or to an online donation site.                                                                      |

  Scenario: Display tooltip for each checkbox on the edit form
    Given I am signed in as a charity worker related to "Harrow Bereavement Counselling"
    And I visit the edit page for the organisation named "Harrow Bereavement Counselling"
    Then the following tooltips should exist:
    | label                                                |  tooltip                                                  |
    | Email                                                |  Toggle to change the visibility of your email address    |
    | Address                                              |  Toggle to change the visibility of your telephone number |
    | Telephone                                            |  Toggle to change the visibility of your address          |
