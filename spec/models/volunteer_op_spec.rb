require 'rails_helper'

describe VolunteerOp, type: :model do
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

  describe '#remote_only' do
    let(:first_local) { FactoryGirl.create(:local_volunteer_op, organisation_id: 1) }
    let(:second_local) { FactoryGirl.create(:local_volunteer_op, organisation_id: 1) }
    let(:first_doit) { FactoryGirl.create(:doit_volunteer_op, organisation_id: 1) }
    let(:second_doit) { FactoryGirl.create(:doit_volunteer_op, organisation_id: 1) }

    it 'contains remote ops' do
      expect(VolunteerOp.remote_only).to include(first_doit, second_doit)
    end

    it 'does not contain local ops' do
      expect(VolunteerOp.remote_only).not_to include(first_local, second_local)
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

  describe '#full_address' do
    let(:details) do
      {
        title: 'test',
        description: 'description',
        address: 'Station Rd',
        postcode: 'HA8 7BD',
        organisation_id: 1
      }
    end
    let!(:vol_op) { FactoryGirl.create :volunteer_op, details }

    it 'returns a full address' do
      expect(vol_op.full_address).to eq 'Station Rd, HA8 7BD'
    end
  end

  describe '#address_compelete?' do
    context 'volunteer op has address and postcode' do
      it 'returns true' do
        vol_op = build(:volunteer_op, address: 'not nil', postcode: 'HA1 4HZ')
        expect(vol_op.address_complete?).to be_truthy
      end
    end
    context 'volunteer op does not have address or postcode' do
      it 'returns false' do
        vol_op = build(:volunteer_op, address: nil, postcode: nil)
        expect(vol_op.address_complete?).to be_falsey
      end
    end
  end

  describe 'clear_lat_lng callback' do
    context 'local source' do
      let(:local_vol_op) do
        build(:local_volunteer_op,
              longitude: -0.393924,
              latitude: 51.5843,
              organisation_id: 1)
      end
      context 'without complete address' do
        it 'clears latitude and longitude coordinates' do
          allow(local_vol_op).to receive(:address_complete?).and_return(false)
          local_vol_op.save
          expect(local_vol_op).not_to have_coordinates
        end
      end

      context 'with complete address' do
        it 'keeps latitude and longitude coordinates' do
          allow(local_vol_op).to receive(:address_complete?).and_return(true)
          local_vol_op.save
          expect(local_vol_op).to have_coordinates
        end
      end
    end

    context 'non local source' do
      let(:remote_vol_op) do
        build(:doit_volunteer_op, longitude: -0.393924, latitude: 51.5843)
      end
      context 'without complete address' do
        it 'keeps latitude and longitude coordinates' do
          allow(remote_vol_op).to receive(:address_complete?).and_return(false)
          remote_vol_op.save
          expect(remote_vol_op).to have_coordinates
        end
      end

      context 'with complete address' do
        it 'keeps latitude and longitude coordinates' do
          allow(remote_vol_op).to receive(:address_complete?).and_return(true)
          remote_vol_op.save
          expect(remote_vol_op).to have_coordinates
        end
      end
    end
  end

  describe '.build_by_coordinates' do
    it 'returns volunteer ops grouped by coordinates' do
      org = create(:organisation, address: '', postcode: '', longitude: 77, latitude: 77)
      no_coord1 = create(:volunteer_op, longitude: nil, latitude: nil, organisation: org)
      no_coord2 = create(:volunteer_op, longitude: nil, latitude: nil, organisation: org)
      d_vol_op1 = create(:doit_volunteer_op, longitude: 62, latitude: 10)
      d_vol_op2 = create(:doit_volunteer_op, longitude: 62, latitude: 10)

      loc1 = Location.new(longitude: 77.0, latitude: 77.0)
      loc2 = Location.new(longitude: 62.0, latitude: 10.0)
      l_vol1 = build(:volunteer_op, longitude: 77.0, latitude: 77.0, organisation: org)
      l_vol2 = build(:volunteer_op, longitude: 77.0, latitude: 77.0, organisation: org)

      expect(VolunteerOp.build_by_coordinates.keys).to match_array(
        [loc1, loc2]
      )
      expect(VolunteerOp.build_by_coordinates[loc2]).to match_instance_array(
        [d_vol_op1, d_vol_op2]
      )
      expect(VolunteerOp.build_by_coordinates[loc1]).to match_instance_array(
        [l_vol1, l_vol2]
      )
    end
  end

  describe '.get_source'  do
    it "returns 'local' for different sources" do
      l_vol_op1 = build(:volunteer_op, organisation_id: 1)
      l_vol_op2 = build(:volunteer_op, organisation_id: 1)
      expect(VolunteerOp.get_source([l_vol_op1, l_vol_op2])).to eq('local')
    end
    it "returns 'doit' for different sources" do
      d_vol_op1 = create(:doit_volunteer_op)
      d_vol_op2 = create(:doit_volunteer_op)
      expect(VolunteerOp.get_source([d_vol_op1, d_vol_op2])).to eq('doit')
    end
    it "returns 'mixed' for different sources" do
      l_vol_op1 = build(:volunteer_op, organisation_id: 1)
      d_vol_op2 = create(:doit_volunteer_op)
      expect(VolunteerOp.get_source([l_vol_op1, d_vol_op2])).to eq('mixed')
    end
  end
end
