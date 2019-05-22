Then('I should see the site branding') do
  expect(page).to have_content Setting.site_brand
end
