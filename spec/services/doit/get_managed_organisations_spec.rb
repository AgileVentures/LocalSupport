require 'rails_helper'

module Doit
  RSpec.describe GetManagedOrganisations do

    describe '.call' do
      it 'returns list of managed organisation from Doit' do

        stub_request(:get, "http://api.qa2.do-it.org/v2/users/current/orgs?page=1").
          to_return(:status => 200, :body => File.read('test/fixtures/doit_managed_orgs.json'), :headers => {})
        stub_request(:get, "http://api.qa2.do-it.org/v2/users/current/orgs?page=2").
          to_return(:status => 200, :body => File.read('test/fixtures/doit_empty_items.json'), :headers => {})
        res = GetManagedOrganisations.call
        
        expect(res).to include(
          {
            id: '4dd7dfe2-c281-4170-8f0b-da17e8af5e5d',
            name: 'Help Out Harrow!'
          }
        )
      end
    end
  end
end
