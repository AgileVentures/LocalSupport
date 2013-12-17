require 'spec_helper'

describe ApplicationHelper do
  describe 'smart_truncate' do
    it 'should return empty string when truncating empty string' do
      smart_truncate("").should == ""
    end

    it 'should return empty string when truncating nil' do
      smart_truncate(nil).should == ""
    end

    it 'should return a the same string when the string is short' do
      smart_truncate("test").should == "test"
    end

    it 'should return a truncated string when the string is long' do
      long_string = "TO PROVIDE SAFE AND SATISFYING PLAY FOR PRE-SCHOOL CHILDREN AND TO ENCOURAGE PARENTS TO PARTICIPATE FULLY. THE PRE-SCHOOL SHALL BE OPEN TO ALL WITHOUT DISCRIMINATION."
      expect(smart_truncate(long_string)).to eq "TO PROVIDE SAFE AND SATISFYING PLAY FOR PRE-SCHOOL CHILDREN AND TO ENCOURAGE PARENTS TO PARTICIPATE FULLY. THE PRE-SCHOOL SHALL BE OPEN TO ALL WITHOUT ..."
    end
  end

  describe 'markdown' do
    # tested extensively in features/admin_edit_static_pages.feature
  end

  describe 'cookie_policy_accepted' do
    # more easily tested through cucumber / capybara
  end
end