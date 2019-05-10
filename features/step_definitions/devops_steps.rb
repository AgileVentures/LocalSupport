When(/^I hit the letsencrypt endpoint$/) do
  ENV['CERTBOT_SSL_CHALLENGE'] = 'qwertyui'
  @response = get '/.well-known/acme-challenge/123456789'
end

Then(/^I should receive the correct challenge response$/) do
  expect(@response.body).to eq '123456789.qwertyui'
end

Given(/^I run the import organisation service$/) do
  ImportOrganisations.with
end

Given(/^I run the import kcsc service$/) do
  ImportKCSC.with
end

Then(/^there should be (\d+) organisations stored$/) do |number|
  expect(Organisation.count).to eq number
end

