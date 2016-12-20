Feature: Admin all users page
  As an Admin
  So that I can quickly see which users are in which Organisation
  I would like all orgs hyperlinked and have sorting work
  
  Background:
    Given the following organisations exist:
      | name                           | description                    | address        | postcode | website       |
      | Harrow Bereavement Counselling | Harrow Bereavement Counselling | 34 Pinner Road | HA1 4HZ  | http://a.com/ |
    And the following users are registered:
      | email             | password | superadmin | confirmed_at         |  organisation                   |
      | user@example.com  | pppppppp | true       | 2007-01-01  10:00:00 |  Harrow Bereavement Counselling |
    And I am signed in as a superadmin
    
    Scenario: having org links targeting new page
      When I visit the registered users page
      Then I should see link "Harrow Bereavement Counselling" targeting new page