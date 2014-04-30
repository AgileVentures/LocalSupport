require 'spec_helper'

describe VolunteerOpsHelper do
  describe '#button_text' do
    let(:op) { double :volunteer_op }

    it 'button mentions "Create" when it is a new record' do
      op.stub new_record?: true
      button_text(op).should eq 'Create a Volunteer Opportunity'
    end

    it 'button mentions "Update" when it is NOT a new record' do
      op.stub new_record?: false
      button_text(op).should eq 'Update a Volunteer Opportunity'
    end

    it 'mutation-proofing' do
      op.should_receive :new_record?
      button_text(op)
    end
  end
end
