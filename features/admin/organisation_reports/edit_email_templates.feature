Feature: Superadmin can edit email templates
  As the SuperAdmin
  So that I customize the template of the email sent to Users to better suit them
  I want to have a simple editor allowing me to change the template's content

  Background:
    Given the following users are registered:
      | email                 | password       | superadmin | confirmed_at        | organisation    | pending_organisation |
      | superadmin@myorg.com       | superadminpass0987  | true  | 2008-01-01 00:00:00 | My Organisation |                      |
    And the invitation instructions mail template exists
    And cookies are approved
    And I am signed in as a superadmin

  Scenario: Super Admin can enter edit email template page for invitation instructions
    And I visit the invite users to become admin of organisations page
    And I click "Edit template"
    Then I should be on the edit page for the MailTemplate named "Invitation instructions"

  Scenario: Super Admin can edit email template of invitation instructions
    And I visit the edit page for the MailTemplate named "Invitation instructions"
    And I fill in "Message" with "Test message" within the main body
    And I press "Update template"
    Then I should be on the invite users to become admin of organisations page
    And I should see "Test message" within "preview_email"