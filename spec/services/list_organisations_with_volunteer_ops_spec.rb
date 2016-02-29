require './app/services/list_organisations_with_volunteer_ops'

describe ListOrganisationsWithVolunteerOps do

  let(:orgs) { double :orgs }
  let(:all_orgs_with_volops) { double :all_orgs_with_volops }
  let(:markers) { double :markers }
  let(:listener) { double :listener }
  let(:scope) { :all }
  let(:model) { double :organisation }

  before do
    expect(listener).to receive(:build_map_markers).with(orgs)
                          .and_return(markers)
    expect(model).to receive(:joins).with(:volunteer_ops)
                       .and_return(all_orgs_with_volops)
  end

  context 'all kinds of volops' do

    subject(:list_orgs_with_vol_ops) do
      ListOrganisationsWithVolunteerOps.with(listener, scope, model)
    end

    before do
      expect(all_orgs_with_volops).to receive(scope)
                                        .and_return(orgs)
    end

    it 'returns markers and orgs' do
      expect(list_orgs_with_vol_ops).to eq [markers, orgs]
    end
  end

  context 'only local site volops' do
    let(:local_site_scope) { :local_only }

    subject(:list_orgs_with_vol_ops) do
      ListOrganisationsWithVolunteerOps.with(listener, local_site_scope, model)
    end

    before do
      expect(all_orgs_with_volops).to receive(local_site_scope)
                                        .and_return(orgs)
    end

    it 'returns markers and orgs for the local site' do
      expect(list_orgs_with_vol_ops).to eq [markers, orgs]
    end
  end

end