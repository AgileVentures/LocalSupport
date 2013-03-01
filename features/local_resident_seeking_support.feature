Feature: Local Resident seeking Support
  As a local resident
  So that I can get support for a specific condition
  I want to find contact details for a local service specific to my need

Background: organizations have been added to database
  
  Given the following organizations exist:
  | name                            | description               |
  | Harrow Bereavement Counselling  | Bereavement Counselling   | 
  | Indian Elders Associaton        | Care for the elderly      | 
  | Age UK                          | Care for the elderly      | 

# particularly want to provide visibility to organizations with no existing web presence
Scenario: Find help with care for elderly
  Given I am on the home page
  When I search for "elderly"
  Then I should see contact details for "Indian Elders Associaton" and "Age UK"

# starting within main site
Scenario: Find a bereavement counsellor
  Given I am on the home page
  When I search for "Bereavement Counselling"
  Then I should see contact details for "Harrow Bereavement Counselling"



# starting with web search
Scenario: Searching Google for "death of a relative"
