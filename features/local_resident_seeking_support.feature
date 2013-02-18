Feature: Local Resident seeking Support
  As a local resident
  So that I can get support for a specific condition
  I want to find contact details for a local service specific to my need

# starting within main site
Scenario: Find a bereavement counsellor
  Given I am on the home page
  When I search for "Bereavement Counselling"
  Then I should see contact details for "Harrow Bereavement Counselling"

Scenario: Find help with care for elderly
  Given I am on the home page
  When I search for "help for elderly relative"
  Then I should see contact details for "Indian Elders Associaton" and "Age UK"

# starting with web search
Scenario: Searching Google for "death of a relative"
