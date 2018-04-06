Feature: Allow superadmin to upgrade individual users to site admin
  As a super admin
  So that I can share management of the site effectively
  I would like to be able to upgrade regular users to site admin status
  
Background: users have been added to database
    Given the following users are registered:
      | email                         | password | superadmin | confirmed_at         |
      | registered-user-1@example.com | pppppppp | true       | 2018-03-30  10:00:00 |
      | registered-user-2@example.com | pppppppp | false      | 2018-03-30  10:00:00 |
 
 Scenario: Regular users have the Upgrade button
   Given I am signed in as a superadmin
   When I visit the registered users page
   Then I should see for "registered-user-2@example.com" the "Upgrade" button
   
  Scenario: User gets upgraded when superadmin click the Upgrade button
    Given I am signed in as a superadmin
    And I visit the registered users page
    When I click on "Upgrade" for the user "registered-user-2@example.com"
    Then I should see "You have successfully upgraded user registered-user-2@example.com"
    When I click on "Upgrade" for the user "registered-user-1@example.com"
    Then I should see "User already site admin!"
    
  Scenario: Upgraded user has the same privileges as siteadmin
    Given I visit the sign in page
    And I sign in as "registered-user-2@example.com" with password "pppppppp"
