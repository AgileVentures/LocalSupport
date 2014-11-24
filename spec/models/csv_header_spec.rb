require_relative '../../app/models/csv_header'

describe CSVHeader, :type => :model do
  let(:value) { CSVHeader.build }

  context "column names" do
    subject { value }

    it { expect(subject.name).to eq 'Title' }
    it { expect(subject.address).to eq 'Contact Address' }
    it { expect(subject.description).to eq 'Activities' }
    it { expect(subject.website).to eq 'website' }
    it { expect(subject.telephone).to eq 'Contact Telephone' }
    it { expect(subject.date_removed).to eq 'date removed' }
    it { expect(subject.cc_id).to eq 'Charity Classification' }
  end

end
