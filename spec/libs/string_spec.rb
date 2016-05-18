require 'rails_helper'
require 'string.rb'

describe String do

  describe '#short_name' do
    
    it 'as default returns first three words joined by dashes' do
      org = 'better world charity london'
      expect(org.short_name).to eq('better-world-charity')
    end
    
    it 'creating slug omits words - the, of, for, and, in, to' do
      org = 'to the and in of better world for charity'
      expect(org.short_name).to eq('better-world-charity')
    end

    it 'returns special parochial church slug when organisation is a parochial church' do
      org = 'parochial church parish of st lucas'
      expect(org.short_name).to eq('parochial-church-st-lucas')
    end
  
  end
  
  describe '#longer_name' do
    
    it 'returns first three words and two last words joined by dashes' do
      org = 'better world charity london robert baratheon'
      expect(org.longer_name).to eq('better-world-charity-robert-baratheon')
    end
    
    it 'creating slug omits words - the, of, for, and, in, to' do
      org = 'to the and in of better world for charity london robert baratheon'
      expect(org.longer_name).to eq('better-world-charity-robert-baratheon')
    end

  end

  describe '#append_org' do

    it 'returns all words and word "org" joined by dashes' do
      org = 'better world charity london robert baratheon'
      expect(org.append_org).to eq('better-world-charity-london-robert-baratheon-org')
    end
    
    it 'creating slug omits words - the, of, for, and, in, to' do
      org = 'to the and in of better world for charity london robert baratheon'
      expect(org.append_org).to eq('better-world-charity-london-robert-baratheon-org')
    end

  end
end