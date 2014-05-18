require 'spec_helper'

describe Invitations::KeyMapper do
  let(:params) do
    {
        'resend_invitation' => '',
        'invite_list' => [{
            'id' => '',
            'email' => ''
        }]
    }
  end

  it 'permits the given params structure' do
    expect(->{described_class.(params)}).to_not raise_error
  end

  it 'barfs if any of the given params structure is missing' do
    %w(resend_invitation invite_list).each do |key|
      less_params = params.clone
      less_params.delete(key)
      expect(->{described_class.(less_params)}).to raise_error KeyError, "key not found: \"#{key}\""
    end
    %w(id email).each do |key|
      less_params = params['invite_list'].first.clone
      less_params.delete(key)
      less_params = params.clone.update('invite_list' => [less_params])
      expect(->{described_class.(less_params)}).to raise_error KeyError, "key not found: \"#{key}\""
    end
  end
end