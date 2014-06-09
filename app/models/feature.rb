# Provides feature flags.
# ======================
# To create a new feature flag
#
#   Feature.create(:name => :my_feature_name)
#
# By default, features are inactive.
# Test if your feature is active with
#
#   Feature.active?(:my_feature_name)
#
# Deactivate it and reactivate it with (just like the rollout gem):
#
#   Feature.deactivate(:my_feature_name)
#   Feature.activate(:my_feature_name)
#
# In config/routes.rb, add this as a constraint to the route you want to flag. 
# 
#   constraints: lambda { |request| Feature.active?(:my_feature_name) }

class Feature < ActiveRecord::Base
  attr_accessible :name, :active
  validates :name, presence: true, uniqueness:true, allow_blank: false

  def self.deactivate(feature)
    find_by_name(feature).update_attribute(:active, false)
  end

  def self.activate(feature)
    find_by_name(feature).update_attribute(:active, true)
  end

  def self.active?(feature)
    flag = find_by_name(feature)
    flag.nil? ? false : flag.active?
  end
end
