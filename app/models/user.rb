class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
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
  belongs_to :pending_organization, :class_name => 'Organization', :foreign_key => 'pending_organization_id'

  scope :invited_not_accepted,
    includes(:organization).
    #where('users.organization_id IS NOT NULL').
    where('users.invitation_sent_at IS NOT NULL').
    where('users.invitation_accepted_at IS NULL')

  def confirm!
    super
    make_admin_of_org_with_matching_email
  end

  def belongs_to? organization
    self.organization == organization
  end

  def can_edit? org
    admin? || (!org.nil? && organization == org)
  end

  def can_delete? org
    admin?
  end

  def can_request_org_admin? org
    # admin false, pending_organization  pending_organization!=organization org != organization
    !admin? && organization != org && pending_organization != org
  end

  def make_admin_of_org_with_matching_email
    org = Organization.find_by_email self.email
    self.organization = org if org
    save!
  end

  def promote_to_org_admin
    # self required with setter method: http://stackoverflow.com/questions/5183664/why-isnt-self-always-needed-in-ruby-rails-activerecord/5183917#5183917
    self.organization_id = pending_organization_id
    self.pending_organization_id = nil
    save!
  end

  def request_admin_status(organization_id)
    self.pending_organization_id = organization_id
    save!
  end
end
