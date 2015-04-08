class SearchParamsParser

  attr_reader :params
  def initialize(params)
    @params = params
  end

  def query_term
    @query_term ||= params.fetch(:q)
  end

  def what_who_how_ids
    @what_who_how_ids ||=
      [
        what_id, who_id, how_id
      ].reject(&:empty?)
  end

  def what_id
    @what_id ||= params.require(:what).permit(:id).fetch(:id)
  end

  def who_id
    @who_id ||= params.require(:who).permit(:id).fetch(:id)
  end

  def how_id
    @how_id ||= params.require(:how).permit(:id).fetch(:id)
  end
end
