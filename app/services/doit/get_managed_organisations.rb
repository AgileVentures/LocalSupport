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
      options = {}
      options[:headers] = { "X-API-Key" => ENV["X-AUTH-TOKEN"] }
      options[:query] = { page: 1 }

      loop do
        response = http.get("#{ENV["DOIT_HOST"]}#{organisations_resource}", options)
        records = JSON.parse(response.body)['data']['items']
        if records.try(:any?)
          records.each { |record| yield record }
          options[:query][:page] += 1
        else
          break # no items included on that page
        end
      end
    end

  end
end
