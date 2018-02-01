class UpdateSocialMedia
  attr_reader :twitter_client

  def initialize
    @twitter_client = TwitterApi.new
  end

  def update_social_media
    within_one_day = (Time.current - 1.day)..Time.current
    new_volops = VolunteerOp.where(created_at: within_one_day).where.not source: :local
    new_volops.each { |volop| post volop }
  end

  def post volop
    twitter_client.tweet volop
  end
end
