module Queries
  class Organisations

    attr_reader :query_term, :organisations, :params
    def initialize(query_term, organisations, params)
      @query_term = query_term
      @organisations = organisations
      @params = params
    end

    def search_by_keyword_and_category
      categories = what_ids + who_ids + how_ids
      organisations.search_by_keyword(
        query_term
      ).filter_by_categories(
        categories
      )
    end


    def what_id
      @what_id ||= params.require(:what).permit(:id).fetch(:id)
    end

    def how_id
      @how_id ||= params.require(:how).permit(:id).fetch(:id)
    end

    def who_id
      @who_id ||= params.require(:who).permit(:id).fetch(:id)
    end

    def what_ids
      if what_id.empty?
        Category.what_they_do.select(:id)
      else
        Array.wrap(what_id)
      end
    end

    def who_ids
      if who_id.empty?
        Category.who_they_help.select(:id)
      else
        Array.wrap(who_id)
      end
    end

    def how_ids
      if how_id.empty?
        Category.how_they_help.select(:id)
      else
        Array.wrap(how_id)
      end
    end

  end

end
