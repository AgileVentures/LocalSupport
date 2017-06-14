module Doit
  class PostToDoit
    include StringUtility

    # API reference:
    # http://docs.doit.apiary.io/#reference/opportunities/opportunities/create?console=1

    def doit_volonteer_op_resource
      '/opportunities'
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      options = {}

      options[:headers] = { 'X-API-Key' => DOIT_AUTH_TOKEN,
                            'Content-Type' => 'application/json' }
      options[:body] = build_request_body
      http_adapter.post("#{ENV['DOIT_HOST']}#{doit_volonteer_op_resource}", options)

    end

    private

    attr_reader :volunteer_op,
      :advertise_start_date, :advertise_end_date,
      :doit_org_id,
      :http_adapter

    def initialize(volunteer_op:, advertise_start_date:, advertise_end_date:, doit_org_id:, http_adapter: HTTParty)
      @volunteer_op = volunteer_op
      @advertise_start_date = advertise_start_date
      @advertise_end_date = advertise_end_date
      @doit_org_id = doit_org_id
      @http_adapter = http_adapter
    end

    def build_request_body
      {
        advertise_start_date: advertise_start_date,
        advertise_end_date: advertise_end_date,
        blurb: smart_truncate(volunteer_op.description),
        description: volunteer_op.description,
        owner_recruiter_id: doit_org_id,
        locations: [
          {
            address: volunteer_op.address,
            postcode: volunteer_op.postcode,
            location_type: "SL",
            lat: volunteer_op.latitude,
            lng: volunteer_op.longitude
          }
        ],
        title: volunteer_op.title
      }.to_json
    end
  end
end
