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
      :postcode => 'HA1 3TE',
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
      :postcode => 'HA1 3RE',
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
      :postcode => 'HA1 3RE',
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

end
