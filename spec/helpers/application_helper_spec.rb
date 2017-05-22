require 'rails_helper'

describe ApplicationHelper, :type => :helper do
  describe 'smart_truncate' do
    it 'should return empty string when truncating empty string' do
      expect(smart_truncate("")).to eq("")
    end

    it 'should return empty string when truncating nil' do
      expect(smart_truncate(nil)).to eq("")
    end

    it 'should return a the same string when the string is short' do
      expect(smart_truncate("test")).to eq("test")
    end

    it 'should return a truncated string when the string is long' do
      long_string = "TO PROVIDE SAFE AND SATISFYING PLAY FOR PRE-SCHOOL CHILDREN AND TO ENCOURAGE PARENTS TO PARTICIPATE FULLY. THE PRE-SCHOOL SHALL BE OPEN TO ALL WITHOUT DISCRIMINATION."
      expect(smart_truncate(long_string)).to eq "TO PROVIDE SAFE AND SATISFYING PLAY FOR PRE-SCHOOL CHILDREN AND TO ENCOURAGE PARENTS TO PARTICIPATE FULLY. THE PRE-SCHOOL SHALL BE OPEN TO ALL WITHOUT ..."
    end
  end

  describe 'markdown' do
    # tested extensively in features/superadmin_edit_static_pages.feature
  end

  describe '#cookie_policy_accepted?' do
    it 'true with the cookie' do
      helper.cookies['cookie_policy_accepted'] = true
      expect(cookie_policy_accepted?).to be true
    end
    it 'false without the cookie' do
      expect(cookie_policy_accepted?).to be false
    end
  end

  describe '#active_if' do
    it 'returns "active" if the controller matches the given argument' do
      str1 = 'str1' ; str2 = 'str2'
      expect(active_if(str1)).to be nil
      params[:controller] = str1
      expect(active_if(str1)).to eq 'active'
      expect(active_if(str2)).to be nil
    end
  end

  describe "#feature_active?" do
    it 'should return true if feature is active' do
      allow(Feature).to receive_messages(active?: true)
      expect(helper.feature_active?(:volunteer_ops)).to be true
    end

    it 'should return false if feature is inactive' do
      allow(Feature).to receive_messages(active?: false)
      expect(helper.feature_active?(:volunteer_ops)).to be false
    end
  end

  describe '#parent_layout' do
    subject(:parent_layout) { helper.parent_layout('application') }

    let(:view_flow) { double :view_flow, set: true, get: true }
    let(:result) { double :result }

    before do
      allow(helper).to receive(:render)
      assign(:view_flow, view_flow)
    end

    it 'sets view_flow layout to output buffer' do
      expect(view_flow).to receive(:set).with(:layout, helper.output_buffer)
      parent_layout
    end

    it 'renders the parent layout' do
      expect(helper).to receive(:render).with(file: 'layouts/application')
      parent_layout
    end

    it 'sets the output buffer to the rendered layout' do
      allow(helper).to receive(:render).and_return(result)
      expect(helper).to receive(:output_buffer=).with(result)
      parent_layout
    end
  end
end
