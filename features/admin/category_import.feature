Feature: import categories from CSV
  As a Site Super Admin
  So that Organisations can be categorized in accordance with governmental designations
  I want to import external lists of Categories and associate them with Organisations


  Scenario:
    Given I can run the rake task "bundle exec rake db:cat_org_import"
    # TODO: check rake task actually associates Categories with Organizations

#  Scenario: run rake task
#    Given I import categories from CSV
#    Then I should see more Categories associated with a Organisation


