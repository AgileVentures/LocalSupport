require 'rails_helper'

describe BaseOrganisation do
  describe '#slug' do

    it 'provides short_name as first alternative' do
      org = FactoryGirl.create(:friendly_id_org)
      expect(org.slug).to eq('most-noble-great')
    end

    it 'provides longer_name as slug as second' do
      FactoryGirl.create(:friendly_id_org)
      org = FactoryGirl.build(:friendly_id_org)
      expect(org.slug).to eq('most-noble-great-charity-london')
    end

    it 'provides append_org as slug as third' do
      2.times { FactoryGirl.create(:friendly_id_org) }
      org = FactoryGirl.build(:friendly_id_org)
      expect(org.slug).to eq('most-noble-great-charity-london-org')
    end

    it 'provides full name as slug as fourth' do
      3.times { FactoryGirl.create(:friendly_id_org) }
      org = FactoryGirl.build(:friendly_id_org)
      expect(org.slug).to eq('the-most-noble-great-charity-of-london')
    end

    it 'provides special name for parochial churches' do
      org = FactoryGirl.create(:parochial_org)
      expect(org.slug).to eq('parochial-church-st-alban-north')
    end

  end
end

