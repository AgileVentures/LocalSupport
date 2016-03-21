require 'rails_helper'

describe VolunteerOp, :type => :model do
  it 'must have a title' do
    v = VolunteerOp.new(title: '')
    v.valid?
    expect(v.errors[:title].size).to eq(1)
  end

  it 'must have a description' do
    v = VolunteerOp.new(description: '')
    v.valid?
    expect(v.errors[:description].size).to eq(1)
  end

  it 'must not be created without an organisation' do
    v = VolunteerOp.new(organisation_id: nil)
    v.valid?
    expect(v.errors[:organisation_id].size).to eq(1)
  end

  describe '#local_only' do
    let(:organisation) { FactoryGirl.create(:organisation) }
    let(:first_local) { FactoryGirl.create(:local_volunteer_op, organisation: organisation) }
    let(:second_local) { FactoryGirl.create(:local_volunteer_op, organisation: organisation) }
    let(:first_doit) { FactoryGirl.create(:doit_volunteer_op, organisation: organisation) }
    let(:second_doit) { FactoryGirl.create(:doit_volunteer_op, organisation: organisation) }

    it 'must contain local ops' do
      expect(VolunteerOp.local_only).to include(first_local, second_local)
    end
    it 'must contain only local ops' do
      expect(VolunteerOp.local_only).not_to include(first_doit, second_doit)
    end
  end

  describe '#organisation_name' do

    context 'doit org' do
      let(:doit_org_name) { 'Nice Org' }
      let(:vol_op) { FactoryGirl.create(:doit_volunteer_op, doit_org_name: doit_org_name) }

      it 'returns the doit org name' do
        expect(vol_op.organisation_name).to eq doit_org_name
      end
    end

    context 'local org' do
      let(:organisation) { FactoryGirl.create(:organisation, name: "Friendly") }
      let(:vol_op) { FactoryGirl.create(:local_volunteer_op, organisation: organisation) }

      it 'returns the local org name' do
        expect(vol_op.organisation_name).to eq organisation.name
      end
    end

  end

  describe '#organisation_link' do
    context 'doit org' do

      let(:doit_org_link) { 'niceorg' }
      let(:vol_op) { FactoryGirl.create(:doit_volunteer_op, doit_org_link: doit_org_link) }

      it 'returns the doit org link' do
        expect(vol_op.organisation_link).to eq "https://do-it.org/organisations/#{doit_org_link}"
      end
    end

    context 'local org' do

      let(:organisation) { FactoryGirl.create(:organisation, name: "Friendly") }
      let(:vol_op) { FactoryGirl.create(:local_volunteer_op, organisation: organisation) }

      it 'returns the local org' do
        expect(vol_op.organisation_link).to eq organisation
      end
    end
  end

  describe '#link' do
    context 'doit org' do

      let(:doit_op_id) { '456789uyffgh' }
      let(:vol_op) { FactoryGirl.create(:doit_volunteer_op, doit_op_id: doit_op_id) }

      it 'returns the doit op link' do
        expect(vol_op.link).to eq "https://do-it.org/opportunities/#{doit_op_id}"
      end
    end

    context 'local org' do

      let(:organisation) { FactoryGirl.create(:organisation, name: "Friendly") }
      let(:vol_op) { FactoryGirl.create(:local_volunteer_op, organisation: organisation) }

      it 'returns the local op' do
        expect(vol_op.link).to eq vol_op
      end
    end
  end

  describe 'destroy uses acts_as_paranoid' do
    let!(:volunteer_op) { FactoryGirl.create :volunteer_op, organisation_id: 1 }
    it 'can be restored' do
      expect { volunteer_op.destroy }.not_to change(VolunteerOp.with_deleted, :count)
    end
  end

  describe '#search_by_keyword' do
    let(:details1) { {title: 'test', description: 'description1', organisation_id: 1} }
    let(:details2) { {title: 'Good', description: 'description2', organisation_id: 1} }
    let!(:vol_op1) { FactoryGirl.create :volunteer_op, details1 }
    let!(:vol_op2) { FactoryGirl.create :volunteer_op, details2 }

    it 'find records where title or description match search text' do
      expect(VolunteerOp.search_for_text('good')).to eq([vol_op2])
    end
  end
end
