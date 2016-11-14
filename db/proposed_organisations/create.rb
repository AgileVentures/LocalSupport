module Db
  module ProposedOrganisations
    class Create
      def initialize(attributes)
        @attributes = attributes
      end

      def perform
        ProposedOrganisation.create!(
          default_attributes.merge(
            attributes.except('proposer_email')
          ).merge('users' => users)
        )
      end

      private

      attr_reader :attributes

      def default_attributes
        {
          'name'          => 'Unfriendly',
          'description'   => 'Mourning loved ones',
          'address'       => '30 pinner road',
          'postcode'      => 'HA5 4HZ',
          'telephone'     => '520800000',
          'website'       => 'http://unfriendly.org',
          'email'         => 'unfriendly@example.com',
          'donation_info' => 'www.pleasedonate.com',
          'non_profit'    => true,
        }
      end

      def users
        User.where(email: attributes['proposer_email'])
      end
    end
  end
end
