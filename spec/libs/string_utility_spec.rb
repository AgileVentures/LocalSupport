require 'rails_helper'

class Parent
  include StringUtility
end

RSpec.describe StringUtility do
  describe '.smart_truncate' do
    it 'should return empty string when truncating empty string' do
      expect(Parent.new.smart_truncate("")).to eq("")
    end

    it 'should return empty string when truncating nil' do
      expect(Parent.new.smart_truncate(nil)).to eq("")
    end

    it 'should return a the same string when the string is short' do
      expect(Parent.new.smart_truncate("test")).to eq("test")
    end

    it 'should return a truncated string when the string is long' do
      long_string = "TO PROVIDE SAFE AND SATISFYING PLAY FOR PRE-SCHOOL CHILDREN AND TO ENCOURAGE PARENTS TO PARTICIPATE FULLY. THE PRE-SCHOOL SHALL BE OPEN TO ALL WITHOUT DISCRIMINATION."
      expect(Parent.new.smart_truncate(long_string)).to eq "TO PROVIDE SAFE AND SATISFYING PLAY FOR PRE-SCHOOL CHILDREN AND TO ENCOURAGE PARENTS TO PARTICIPATE FULLY. THE PRE-SCHOOL SHALL BE OPEN TO ALL WITHOUT ..."
    end
  end
end
