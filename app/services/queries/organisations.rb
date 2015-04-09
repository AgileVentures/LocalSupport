module Queries
  module Organisations

    def self.search_by_keyword_and_category(parsed_params)
      organisations =
        Organisation.order_by_most_recent.search_by_keyword(
          parsed_params.query_term
        )

      # organisations = Organisation.all
      if parsed_params.what_who_how_ids.any?
        organisations.filter_by_categories(
          parsed_params.what_who_how_ids
        )
      else
        organisations
      end
    end

  end
end
