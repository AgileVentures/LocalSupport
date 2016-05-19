require 'rails_helper'

describe SetupSlug do
  subject(:setup_slug) { described_class }
  let(:string) { 'test' }

  it 'returns true when arg is nil' do
    expect(setup_slug.run(nil)).to be nil
  end

  it 'uses short name as slug in first instance' do
    expect(setup_slug.run(string).first).to eq(string.method(:short_name))
  end

  it 'uses longer name as slug in second instance' do
    expect(setup_slug.run(string).second).to eq(string.method(:longer_name))
  end

  it 'uses append org as slug in third instance' do
    expect(setup_slug.run(string).third).to eq(string.method(:append_org))
  end

  it 'uses original name as slug in fourth instance' do
    expect(setup_slug.run(string).fourth).to eq(:name)
  end

end