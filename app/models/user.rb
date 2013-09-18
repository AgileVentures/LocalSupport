class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # http://stackoverflow.com/a/4558910/2197402
  # http://api.rubyonrails.org/classes/ActiveModel/Dirty.html
  # http://guides.rubyonrails.org/active_record_callbacks.html#using-if-and-unless-with-a-proc
  #after_save :promote_new_user,
  #           :if => proc { |usr| usr.confirmed_at_was.nil? && usr.confirmed_at_changed?}

  # Setup accessible (or protected) attributes for your model
  # prevents mass assignment on other fields not in this list
  attr_accessible :email, :password, :password_confirmation, :remember_me
  belongs_to :organization

  def confirm!
    super
    promote_new_user
  end
  
  def can_edit? org
    admin? || (!org.nil? && organization == org)
  end

  def promote_new_user
    orgs = Organization.all
    emails = orgs.collect {|org| org.email}
    if emails.include? email
      # users to orgs is many to one
      # but org emails aren't required to be unique
      # so if a site admin sets up multiple charities with the same email, we've got a problem
      # for now, I will take only the first match
      #TODO Let promoted user be promoted for all matching orgs
      org = orgs.find {|o| o.email == email}
      org.update_attributes_with_admin({:admin_email_to_add => email})
    end
  end



end

