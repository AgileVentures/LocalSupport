require 'rails_helper'

RSpec.describe UpdateSocialMedia do
  before :each do
    organisation = FactoryBot.create :organisation, name: 'Friendly'
    FactoryBot.create :doit_volunteer_op, source: 'doit'
    FactoryBot.create :doit_volunteer_op, source: 'doit'
    FactoryBot.create :doit_volunteer_op, source: 'doit', created_at: 1.day.ago
    FactoryBot.create :local_volunteer_op, source: 'local', organisation: organisation
  end

  context 'Posting to Twitter' do
    # Currently reachskills ops are not tweeted due to api constraints
    # See Pivotal Tracker story: https://www.pivotaltracker.com/story/show/153805125
    it 'tweets only new doit ops' do
      expect_any_instance_of(UpdateSocialMedia).to receive(:post).exactly(2).times
      UpdateSocialMedia.new.post_new_volops_from_partner_sites
    end
  end
end
