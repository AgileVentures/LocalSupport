# Twitter API configuration for Testing

# The hard coded credentials are for the twitter
# account agileVenturTest which was created for
# testing purposes. All tweets for this account
# are protected.
# https://twitter.com/agileVenturTest

if Rails.env.test?
  ENV["TWITTER_CONSUMER_KEY"]         = "NYUqRmZOGF8tuIwaIRTwX2fa5"
  ENV["TWITTER_CONSUMER_SECRET"]      = "m8oS1jF445HJfhsKjLyJ47x9VUM8mTijZaV9xMSXilCTZSE7NI"
  ENV["TWITTER_ACCESS_TOKEN"]         = "878610381563990016-FeYOp32CtyIu9v4E6ydCJI1cDF2KILw"
  ENV["TWITTER_ACCESS_TOKEN_SECRET"]  = "RlPKfOx00Ry4DNFLAWLAtae4G2J5ERPk8FFge2egrYSS6"
end

# These values depend on the the client's twitter application
# These values should NEVER be checked into source control
if Rails.env.production?
  ENV["TWITTER_CONSUMER_KEY"]         = ""
  ENV["TWITTER_CONSUMER_SECRET"]      = ""
  ENV["TWITTER_ACCESS_TOKEN"]         = ""
  ENV["TWITTER_ACCESS_TOKEN_SECRET"]  = ""
end