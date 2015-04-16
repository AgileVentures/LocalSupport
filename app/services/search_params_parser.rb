class SearchParamsParser

  attr_reader :params
  def initialize(params)
    @params = params.permit(
      :q,
      :what_id,
      :who_id,
      :how_id,
    )
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
    @what_id ||= params.fetch(:what_id)
  end

  def who_id
    @who_id ||= params.fetch(:who_id)
  end

  def how_id
    @how_id ||= params.fetch(:how_id)
  end
end
