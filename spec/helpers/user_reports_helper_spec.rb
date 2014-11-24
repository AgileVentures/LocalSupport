require 'rails_helper'

describe UserReportsHelper, :type => :helper do
  describe '#time_ago_in_words_with_nils' do
    it 'should handle nils' do
      expect(time_ago_in_words_with_nils(nil)).to eq 'never'
    end
    it 'should handle times' do
      expect(time_ago_in_words_with_nils(3.days.ago)).to eq '3 days ago'
    end
  end
end
