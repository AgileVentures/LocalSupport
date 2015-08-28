# http://pivotallabs.com/cucumber-step-definitions-are-not-methods/

module Helpers
  # call on html, dont use <> for tags
  def collect_tag_contents(html, tag)
    Nokogiri::HTML(html).css("#{tag}").collect {|node| node.text.strip}
  end

  # collects a list of text and embedded hyperlinks
  def collect_links(html)
    Hash[Nokogiri::HTML(html).css('a').collect {|node| [node.text.strip, node.attributes['href'].to_s]}]
  end

  def password_url(token)
    Rails.application.routes.url_helpers.edit_user_password_path(reset_password_token: token)
  end

  def confirmation_url(token)
    Rails.application.routes.url_helpers.user_confirmation_path(confirmation_token: token)
  end

  def invitation_url(token)
    Rails.application.routes.url_helpers.accept_user_invitation_path(invitation_token: token)
  end

  # http://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

module MapHelpers
  def stub_request_with_address(address, body = nil)
    filename = "#{address.gsub(/\s/, '_')}.json"
    filename = File.read "test/fixtures/#{filename}"
    stub_request(:any, /maps\.googleapis\.com/).
        to_return(status => 200, :body => body || filename, :headers => {})
  end
end

module ProposedOrgHelpers
  def unsaved_proposed_organisation(associated_user = nil)
    proposed_org = ProposedOrganisation.new({name: "Friendly Charity", description: "We are friendly!",
      email: "sample@sample.org", address: "30 pinner road", donation_info: "https://www.donate.com",
      postcode: 'HA1 4JD', non_profit: true})
    stub_request_with_address("30 pinner road")
    proposed_org.users << associated_user if associated_user
    proposed_org
  end
  def proposed_org_categories
    [ 'Animal welfare',
      'Accommodation',
      'Education',
      'Give them things' ]
  end

  def proposed_org_fields
    {
      name: 'Friendly charity',
      address: '64 pinner road',
      description: 'Such friendly so charity'
    }
  end
end

World(Helpers, MapHelpers, ProposedOrgHelpers)
