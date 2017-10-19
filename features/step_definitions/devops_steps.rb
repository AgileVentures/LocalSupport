When(/^I hit the letsencrypt endpoint$/) do
  ENV['CERTBOT_SSL_CHALLENGE'] = 'qwertyui'
  @response = get '/.well-known/acme-challenge/123456789'
end

Then(/^I should receive the correct challenge response$/) do
  expect(@response.body).to eq '123456789.qwertyui'
end