Feature: Site language translation
  As a user whom does not speak British English
  In order to use the site
  I want to have an easy way to translate the site to my language of choice
  Tracker story ID: https://www.pivotaltracker.com/story/show/75772526

  Background: Translate widget available on home page
    Given I visit the home page
    Then I should see a "Select Language" widget

  @javascript
  Scenario: Translate site language to French and back
    When I select language "French"
    # brittle: tests break when translation is corrected
    And I should see "Recherche pour les organismes bénévoles et communautaires locaux"
    And I should not see "Search for local voluntary and community organisations"
    When I select language "English"
    And I should see "Search for local voluntary and community organisations"
    And I should not see "organizations"

  @javascript
  Scenario: Translate site language to right-to-left language
    Given I accepted the cookie policy from the "home" page
    When I select language "Arabic"
    And I should see "بحث عن المنظمات الطوعية والمجتمع المحلي"
    And I should not see "Search for local voluntary and community organisations"

  @javascript
  Scenario: Translate controls and alerts
    When I select language "Turkish"
    # lost the capital S on Submit button
    Then I should see "sunmak"
    # This is Cookie Policy
    And I should see "Çerez Politikası"
    And I should not see "Submit"
    And I should not see "Cookie Policy"


#  Scenario: Google translation service unavailable at start
#    When the service is unavailable on page load
#    Then I should see the page load OK
#    And I should not see a "Select Language" widget
#
#  Scenario: Google translation service becomes unavailable
#    When the service is unavailable after page load
#    Then I should see a "Select Language" widget
#    And it does nothing
