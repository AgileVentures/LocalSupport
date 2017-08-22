module Doit
  class PostToDoit
    include StringUtility

    # API reference:
    # http://docs.doit.apiary.io/#reference/opportunities/opportunities/create?console=1

    def doit_volonteer_op_resource
      "#{ENV['DOIT_HOST']}/opportunities"
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      options = {}

      options[:headers] = {'X-API-Key' => DOIT_AUTH_TOKEN,
                           'Content-Type' => 'application/json'}
      options[:body] = build_request_body
      doit_res = http_adapter.post(doit_volonteer_op_resource, options)
      JSON.parse(doit_res.body)['data']['opportunity']['id']

    end

    private

    attr_reader :volunteer_op,
                :advertise_start_date, :advertise_end_date,
                :doit_org_id,
                :http_adapter

    def initialize(volunteer_op:,
                   advertise_start_date:,
                   advertise_end_date:,
                   doit_org_id:,
                   http_adapter: HTTParty)
      @volunteer_op = volunteer_op
      @advertise_start_date = advertise_start_date
      @advertise_end_date = advertise_end_date
      @doit_org_id = doit_org_id
      @http_adapter = http_adapter
    end



    # rubocop:disable Metrics/MethodLength

    # I guess we could argue we should be extracting an object here, but we're
    # already in a service class, and we're just following a 3rd party API
    # so doesn't make sense to penalize for method length here
    def build_request_body
      {
        advertise_start_date: advertise_start_date,
        advertise_end_date: advertise_end_date,
        blurb: smart_truncate(volunteer_op.description),
        description: volunteer_op.description,
        owner_recruiter_id: doit_org_id,
        locations: locations,
        title: volunteer_op.title
      }.to_json
    end

    # doesn't really make sense to these square and curly braces
    def locations
      [
        {
          address: volunteer_op.address,
          postcode: volunteer_op.postcode,
          location_type: 'SL',
          lat: volunteer_op.latitude,
          lng: volunteer_op.longitude
        }
      ]
    end
    # rubocop:enable Metrics/MethodLength
  end
end
