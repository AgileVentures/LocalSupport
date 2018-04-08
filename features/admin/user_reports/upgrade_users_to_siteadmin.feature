Feature: Allow superadmin to upgrade individual users to site admin
  As a super admin
  So that I can share management of the site effectively
  I would like to be able to upgrade regular users to site admin status
  
Background: Users have been added to database
    Given the following users are registered:
      | email                         | password | superadmin | confirmed_at         |
      | registered-user-1@example.com | pppppppp | true       | 2018-03-30  10:00:00 |
      | registered-user-2@example.com | pppppppp | false      | 2018-03-30  10:00:00 |
 
 Scenario: Users have the Upgrade button
   Given I am signed in as a superadmin
   When I visit the registered users page
   Then I should see for "registered-user-2@example.com" the "Upgrade" button
   
 Scenario: Shows error message when super admin tries to upgrade a site admin
   Given I am signed in as a superadmin
   And I visit the registered users page
   When I click on "Upgrade" for the user "registered-user-1@example.com"
   Then I should see "User already site admin!"
   
 Scenario: Shows success message when super admin tries to upgrade a regular user
   Given I am signed in as a superadmin
   And I visit the registered users page
   When I click on "Upgrade" for the user "registered-user-2@example.com"
   Then I should see "You have successfully upgraded user registered-user-2@example.com"
  
 Scenario: Upgraded user has site admin privileges
   Given superadmin already upgraded "registered-user-2@example.com" user
   And I visit the sign in page
   When I sign in as "registered-user-2@example.com" with password "pppppppp" on the legacy sign in page
   Then I should see "Admin"
