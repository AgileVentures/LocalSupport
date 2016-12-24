Feature: Admin all users page
  As an Admin
  So that I can quickly see which users are in which Organisation
  I would like all orgs hyperlinked and have sorting work
  
  Background:
    Given the following organisations exist:
      | name                           | description                    | address        | postcode | website       |
      | Harrow Bereavement Counselling | Harrow Bereavement Counselling | 34 Pinner Road | HA1 4HZ  | http://a.com/ |
    And the following users are registered:
      | email              | password | superadmin | confirmed_at         |  organisation                   | last_sign_in_at     |
      | santa@claus.com    | hohohoho | true       | 2007-01-01  10:00:00 |  Santa Claus Corp.              |                     |
      | user1@example.com  | pppppppp | true       | 2007-01-01  10:00:00 |  Harrow Bereavement Counselling | 2016-10-01 10:00:00 |
      | user2@example.com  | pppppppp | true       | 2007-01-01  10:00:00 |                                 | 2015-11-01 09:00:00 |
      | user3@example.com  | pppppppp | true       | 2007-01-01  10:00:00 |                                 | 2015-10-01 09:40:00 |
    And I am signed in as a superadmin
    
    Scenario: having org links targeting new page
      When I visit the registered users page
      Then I should see link "Harrow Bereavement Counselling" targeting new page
      
    @javascript
    Scenario: sorting by last sign it date
      When I visit the registered users page
      And I click column header "Last Login"
      Then I should see "user3@example.com" before "user2@example.com"
      And I should see "user2@example.com" before "user1@example.com"
      And I should see "user3@example.com" before "user1@example.com"