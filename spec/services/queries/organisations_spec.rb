require 'rails_helper'

describe Queries::Organisations, '::search_by_keyword_and_category' do
  let!(:category1) { create(:category, :charity_commission_id => 108) }
  let!(:category2) { create(:category, :charity_commission_id => 205) }
  # not initialized!
  let(:category3) { create(:category, :charity_commission_id => 307) }



  let!(:org1) do
    create(
      :organisation,
      :email => "",
      :name => 'Harrow Bereavement Counselling',
      :description => 'Bereavement Counselling',
      :address => '64 pinner road',
      :postcode => 'HA1 4HZ',
      :donation_info => 'www.harrow-bereavment.co.uk/donate',
    )
  end

  let!(:org2) do
    create(
      :organisation,
      :name => 'Indian Elders Association',
      :email => "",
      :description => 'Care for the elderly',
      :address => '64 pinner road',
      :postcode => 'HA1 4HZ',
      :donation_info => 'www.indian-elders.co.uk/donate'
    ).tap { |o| o.categories << category1 ; o.categories << category2 }
  end

  let!(:org3) do
    create(
      :organisation,
      :email => "",
      :name => 'Age UK Elderly',
      :description => 'Care for older people',
      :address => '64 pinner road',
      :postcode => 'HA1 4HZ',
      :donation_info => 'www.age-uk.co.uk/donate',
    ).tap { |o| o.categories  << category1 }
  end

  let(:query_term) { '' }

  let(:parsed_params) do
    double(
      :params,
      query_term: query_term,
      what_who_how_ids: what_who_how_ids.reject(&:empty?),
    )
  end

  def run_spec
    described_class.search_by_keyword_and_category(parsed_params)
  end

  context 'finds all orgs in a particular category' do
    let(:what_who_how_ids) { [category1.id].map(&:to_s) }
    it { expect(run_spec).not_to include org1 }
    it { expect(run_spec).to include org2, org3 }
    it { expect(run_spec.map.size).to eq 2 }
  end

  context 'finds all orgs in several particular categories' do
    let(:what_who_how_ids) { [category1.id, category2.id].map(&:to_s) }
    it { expect(run_spec).not_to include org1, org3 }
    it { expect(run_spec).to include org2 }
    it { expect(run_spec.map.size).to eq 1 }
  end

  context '::order_by_most_recent works' do
    context 'org2 is updated most recently' do
      let(:what_who_how_ids) { [category1.id].map(&:to_s) }
      before { [org3, org2].map(&:touch) }
      it { expect(run_spec).not_to include org1 }
      it { expect(run_spec.map(&:id)).to eq [org2.id, org3.id] }
    end
    context 'org3 is updated most recently' do
      let(:what_who_how_ids) { [category1.id].map(&:to_s) }
      before { [org2, org3].map(&:touch) }
      it { expect(run_spec).not_to include org1 }
      it { expect(run_spec.map(&:id)).to eq [org3.id, org2.id] }
    end
  end

  context 'finds all orgs when all category dropselects are set to "all"' do
    let(:what_who_how_ids) { ['', '', ''] }
    it { expect(run_spec).to include org1, org2, org3 }
  end

  context 'searches by keyword and filters by category and has zero results' do
    let(:query_term) { 'Harrow' }
    let(:what_who_how_ids) { ['1'] }
    it { expect(run_spec).not_to include org1, org2, org3 }
  end

  context 'searches by keyword and filters by category and has results' do
    let(:query_term) { 'Indian' }
    let(:what_who_how_ids) { [category1.id].map(&:to_s) }
    it { expect(run_spec).to include org2 }
    it { expect(run_spec).not_to include org1, org3 }
  end

  context 'searches by keyword even when all category dropselects are set to "all"' do
    let(:query_term) { 'Harrow' }
    let(:what_who_how_ids) { ['', '', ''] }
    it { expect(run_spec).to include org1 }
    it { expect(run_spec).not_to include org2, org3 }
  end

  context 'filters by category when searchss by keyword is nil' do
    let(:query_term) { nil }
    let(:what_who_how_ids) { [category1.id].map(&:to_s) }
    it { expect(run_spec).not_to include org1 }
    it { expect(run_spec).to include org2, org3 }
  end

  context 'returns all orgs when both filter by category and search by keyword are nil args' do
    let(:query_term) { nil }
    let(:what_who_how_ids) { ['', '', ''] }
    it { expect(run_spec).to include org1, org2, org3 }
  end

  context '#add_recently_updated_and_has_owner' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user, email: "blah@blah.org") }
    before do
      org1.update_attributes(updated_at: 2.year.ago)
      org1.users << user1
      org2.users << user2
    end

    it 'computes correctly when scope passed in' do
      orgs = described_class.add_recently_updated_and_has_owner(Organisation.all)
      orgs.each do |o|
        case o.name
          when org1.name
            expect(o.recently_updated_and_has_owner).to be false
          when org2.name
            expect(o.recently_updated_and_has_owner).to be true
          when org3.name
            expect(o.recently_updated_and_has_owner).to be false
        end
      end
    end
  end
end
