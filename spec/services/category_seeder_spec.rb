require_relative '../../app/services/category_seeder' 

describe CategorySeeder, '.seed' do 
  let(:category_repo) { double :category_repo } 
  let(:csv_handler) { double :csv_handler } 
  let(:csv_file) { double :csv_file }

  it 'create a new category based on a parsed csv' do 
    expect(category_repo).to receive(:create_category_from_csv)
    
    described_class.seed(category_repo, csv_handler, csv_file)
  end

end
