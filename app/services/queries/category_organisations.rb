module Queries
  class CategoryOrganisations

    attr_reader :query_term, :organisations, :params
    def initialize(query_term, organisations, params)
      @querty_term = query_term
      @organisations = organisations
      @params = params
    end

    def call
      categories = what_ids + who_ids + how_ids
      organisations.search_by_keyword(
        query_term
      ).filter_by_categories(
        categories
      )
    end

    def what_ids
      id = params.require(:what).permit(:id).values
      if id.first.empty?
        Category.what_they_do.select(:id)
      else
        id
      end
    end

    def who_ids
      id = params.require(:who).permit(:id).values
      if id.first.empty?
        Category.who_they_help.select(:id)
      else
        id
      end
    end

    def how_ids
      id = params.require(:how).permit(:id).values
      if id.first.empty?
        Category.how_they_help.select(:id)
      else
        id
      end
    end

  end

end
