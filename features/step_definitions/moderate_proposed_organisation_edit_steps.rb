Given(/^I click on the all proposed edits link$/) do
  click_link "All Proposed Edits"
end

Then(/^I should not see the all proposed edits link$/) do
  page.should_not have_link href: proposed_organisation_edits_path
end