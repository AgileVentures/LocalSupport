module Queries
  module Organisations

    def self.order_by_most_recent
      # users included for later query about icon size
      Organisation.includes(:users).order_by_most_recent
    end

    def self.search_by_keyword_and_category(parsed_params)
      organisations = order_by_most_recent.search_by_keyword(
        parsed_params.query_term
      )

      if parsed_params.what_who_how_ids.any?
        organisations.filter_by_categories(
          parsed_params.what_who_how_ids
        )
      else
        organisations
      end
    end

    FORMAT = '%Y-%m-%d %H:%M:%S.%N'

    def self.xyz(organisations)
      one_year_ago = Time.current.advance(years: -1)
      recently_updated = "organisations.updated_at > '#{one_year_ago.strftime(FORMAT)}'"
      # recently_updated = "organisations.updated_at > #{one_year_ago.strftime}"
      has_owner = "organisations.id IN (users.organisation_id)"
      condition =
        "CASE WHEN #{recently_updated} AND #{has_owner} THEN TRUE ELSE FALSE END"
      organisations
        .joins('LEFT OUTER JOIN users on users.organisation_id = organisations.id')
        .select("organisations.*, (#{condition}) as recently_updated_and_has_owner")
    end

  end
end
