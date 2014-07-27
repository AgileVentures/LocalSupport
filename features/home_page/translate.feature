Feature: Site language translation
  As a user whom does not speak British English
  In order to use the site
  I want to have an easy way to translate the site to my language of choice
  Tracker story ID: https://www.pivotaltracker.com/story/show/75772526

  Background: Translate widget available on home page
    Given I visit the home page
    Then I should see a "Select Language" widget

#  Scenario: Translate site language in general
#    When I select "Yiddish"
#    Then I should see "אָרגאַניסאַטיאָנס וואָלונטעערס לאָגין פאָרלייגן קיכל פּאָליטיק"
#    And I should not see "Search for local voluntary and community organisations"
#
#  Scenario: Translate works on controls and alerts
#    When I select "Turkish"
#    Then I should see "Sunmak"
#    And I should see "Çerez Politikası"
#    And I should not see "Submit"
#    And I should not see "Cookie Policy"
#
#  Scenario: Translate can return it to the original version
#    When I select "English"
#    Then I should see "Organisation"
#    And I should not see "Organization"
#
#  Scenario: Google translation service unavailable at start
#    Given the service is unavailable on page load
#    Then I should see the page load OK
#    And I should not see a "Select Language" widget
#
#  Scenario: Google translation service becomes unavailable
#    Given the service is unavailable after page load
#    Then I should still see the page load OK
#    And I should not see a "Select Language" widget