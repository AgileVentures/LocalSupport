require_relative '../../app/models/csv_header'

describe CSVHeader do 
  let(:value) { CSVHeader.build }

  context "column names" do 
    subject { value }

    its(:name) { should == 'Title' }
    its(:address) { should == 'Contact Address' }
    its(:description) { should == 'Activities' }
    its(:website) { should == 'website' }
    its(:telephone) { should == 'Contact Telephone' }
    its(:date_removed) { should == 'date removed' }
    its(:cc_id) { should == 'Charity Classification' }
  end

end
