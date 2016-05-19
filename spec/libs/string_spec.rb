require 'rails_helper'
require 'string.rb'

describe String do
  
  describe '#downcase_words' do 
    
    it 'returns an Array' do
      string = ''
      expect(string.downcase_words).to be_an(Array)
    end
    
    it 'filters words with word characters [a-zA-Z0-9_]' do
      string = "~`!@#$%^&*()-+=}]{[|\"':;?/>.<, "
      expect(string.downcase_words).to be_empty
    end
    
    it 'turns filtered words downcase' do
      string = "Bee_hive And Spider\'s Nest"
      expect(string.downcase_words).to eq(['bee_hive', 'and', 'spider', 's', 'nest'])
    end
    
  end
  
  describe '#short_name' do
    
    it 'as default returns first three words joined by dashes' do
      name = 'better world charity london'
      expect(name.short_name).to eq('better-world-charity')
    end
    
    it 'creating slug omits words - the, of, for, and, in, to' do
      name = 'to the and in of better world for charity'
      expect(name.short_name).to eq('better-world-charity')
    end

    it 'returns special parochial church slug when organisation is a parochial church' do
      name = 'parochial church parish of st lucas'
      expect(name.short_name).to eq('parochial-church-st-lucas')
    end
  
  end
  
  describe '#longer_name' do
    
    it 'returns first three words and two last words joined by dashes' do
      name = 'better world charity london robert baratheon'
      expect(name.longer_name).to eq('better-world-charity-robert-baratheon')
    end
    
    it 'creating slug omits words - the, of, for, and, in, to' do
      name = 'to the and in of better world for charity london robert baratheon'
      expect(name.longer_name).to eq('better-world-charity-robert-baratheon')
    end

  end

  describe '#append_org' do

    it 'returns all words and word "org" joined by dashes' do
      name = 'better world charity london robert baratheon'
      expect(name.append_org).to eq('better-world-charity-london-robert-baratheon-org')
    end
    
    it 'creating slug omits words - the, of, for, and, in, to' do
      name = 'to the and in of better world for charity london robert baratheon'
      expect(name.append_org).to eq('better-world-charity-london-robert-baratheon-org')
    end

  end
end