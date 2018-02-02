class UpdateSocialMedia
  attr_reader :twitter_client

  def initialize
    @twitter_client = TwitterApi.new
    @facebook = FacebookApi.new
  end

  def post_new_volops_from_partner_sites
    within_one_day = (Time.current - 1.day)..Time.current
    new_volops = VolunteerOp.where(created_at: within_one_day).where.not source: :local
    new_volops.each { |volop| post volop }
  end

  def post volop
    twitter_client.tweet volop
    facebook.post volop
  end
end
