module Doit
  class GetManagedOrganisations

    # API reference:
    # http://docs.doit.apiary.io/#reference/user/managed-organisations/list?console=1

    def organisations_resource
     '/users/current/orgs' 
    end

    def self.call
      new.call
    end

    def call
      organisations = find_all_accross_pages
      format_result(organisations)
    end


    private
    attr_reader :http

    def initialize(http = HTTParty)
      @http = http
    end

    def find_all_accross_pages
      records = []
      each { |record| records << record }
      records
    end

    def format_result(organisations)
      organisations.map do |org|
        {id: org['id'], name: org['name']}
      end
    end
    
    def each
      options = set_options

      loop do
        get_all_records
      end
    end

    def get_all_records
      response = http.get("#{ENV['DOIT_HOST']}#{organisations_resource}", options)
      records = JSON.parse(response.body)['data']['items']
      break unless records.try(:any?) # no items included on that page
      records.each { |record| yield record }
      options[:query][:page] += 1
    end

    def set_options
      {
        headers: { 'X-API-Key' => DOIT_AUTH_TOKEN },
        query: { page: 1 }
      }
    end

  end
end
