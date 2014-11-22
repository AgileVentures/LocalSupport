require 'rails_helper'

describe VolunteerOpsHelper, :type => :helper do
  describe '#button_text' do
    let(:op) { double :volunteer_op }

    it 'button mentions "Create" when it is a new record' do
      allow(op).to receive_messages new_record?: true
      expect(button_text(op)).to eq 'Create a Volunteer Opportunity'
    end

    it 'button mentions "Update" when it is NOT a new record' do
      allow(op).to receive_messages new_record?: false
      expect(button_text(op)).to eq 'Update a Volunteer Opportunity'
    end

    it 'mutation-proofing' do
      expect(op).to receive :new_record?
      button_text(op)
    end
  end
end
