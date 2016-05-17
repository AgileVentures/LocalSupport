require 'rails_helper'
require 'string.rb'

describe String do
  let(:org) { described_class.new }
  
  describe '#short_name' do
    
    it 'as default returns first three words joined by dashes' do
      org.concat 'better world charity london'
      slug = org.short_name
      expect(slug).to eq('better-world-charity')
    end
    
    it 'creating slug omits words - the, of, for, and, in, to' do
      org.concat 'to the and in of better world for charity'
      slug = org.short_name
      expect(slug).to eq('better-world-charity')
    end

    it 'returns special parochial church slug when organisation is a parochial church' do
      org.concat 'parochial church parish of st lucas'
      slug = org.short_name
      expect(slug).to eq('parochial-church-st-lucas')
    end
  
  end
  
  describe '#longer_name' do
    
    it 'returns first three words and two last words joined by dashes' do
      org.concat 'better world charity london robert baratheon'
      slug = org.longer_name
      expect(slug).to eq('better-world-charity-robert-baratheon')
    end
    
    it 'creating slug omits words - the, of, for, and, in, to' do
      org.concat 'to the and in of better world for charity london robert baratheon'
      slug = org.longer_name
      expect(slug).to eq('better-world-charity-robert-baratheon')
    end

  end

  describe '#append_org' do

    it 'returns all words and word "org" joined by dashes' do
      org.concat 'better world charity london robert baratheon'
      slug = org.append_org
      expect(slug).to eq('better-world-charity-london-robert-baratheon-org')
    end
    
    it 'creating slug omits words - the, of, for, and, in, to' do
      org.concat 'to the and in of better world for charity london robert baratheon'
      slug = org.append_org
      expect(slug).to eq('better-world-charity-london-robert-baratheon-org')
    end

  end
end