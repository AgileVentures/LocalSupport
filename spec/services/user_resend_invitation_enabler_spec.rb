require_relative '../../app/services/resend_invitation_enabler'
describe ResendInvitationEnabler, '.enable' do 
  let(:divisable) { double :divisable } 

  it 'toggles the divisable resend email invitation functionality' do 
    expect(divisable).to receive(:resend_invitation=).with(false)
    described_class.enable(divisable, false)
  end

end
