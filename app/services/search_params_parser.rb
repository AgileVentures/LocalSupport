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
    @query_term ||= params[:q]
  end

  def what_who_how_ids
    @what_who_how_ids ||=
      [
        what_id, who_id, how_id
      ].reject(&:blank?)
  end

  def what_id
    @what_id ||= params[:what_id]
  end

  def who_id
    @who_id ||= params[:who_id]
  end

  def how_id
    @how_id ||= params[:how_id]
  end
end
