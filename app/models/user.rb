class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  acts_as_paranoid
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # http://stackoverflow.com/a/4558910/2197402
  # http://api.rubyonrails.org/classes/ActiveModel/Dirty.html
  # http://guides.rubyonrails.org/active_record_callbacks.html#using-if-and-unless-with-a-proc
  #after_save :promote_new_user,
  #           :if => proc { |usr| usr.confirmed_at_was.nil? && usr.confirmed_at_changed?}

  # Setup accessible (or protected) attributes for your model
  # prevents mass assignment on other fields not in this list
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :pending_organisation_id
  belongs_to :organisation
  belongs_to :pending_organisation, :class_name => 'Organisation', :foreign_key => 'pending_organisation_id'

  # should we have a before_save here where we check if the pending_organization_id is going from
  # nil to a value and then send the superadmin an email ...

  scope :invited_not_accepted,-> {includes(:organisation).where('users.invitation_sent_at IS NOT NULL').where('users.invitation_accepted_at IS NULL')}
  scope :superadmins, -> { where(superadmin: true) }

  def can_create_volunteer_ops? org
    belongs_to?(org) || superadmin?
  end

  def pending_org_admin? org
    return false if self.pending_organisation == nil
    self.pending_organisation == org
  end

  def confirm!
    super
    make_admin_of_org_with_matching_email
  end

  def belongs_to? organisation
    self.organisation == organisation
  end

  # can create or edit an organization
  def can_edit? org
    superadmin? || (!org.nil? && organisation == org)
  end

  def can_delete? org
    superadmin?
  end

  def can_request_org_admin? org
    # superadmin false, pending_organisation  pending_organisation!=organisation org != organisation
    !superadmin? && organisation != org && pending_organisation != org
  end

  def make_admin_of_org_with_matching_email
    org = Organisation.find_by_email self.email
    self.organisation = org if org
    save!
  end

  def promote_to_org_admin
    # self required with setter method: http://stackoverflow.com/questions/5183664/why-isnt-self-always-needed-in-ruby-rails-activerecord/5183917#5183917
    self.organisation_id = pending_organisation_id
    self.pending_organisation_id = nil
    save!
  end

  def request_admin_status(organisation_id)
    self.pending_organisation_id = organisation_id
    save!
  end

  def self.purge_deleted_users_where(query)
    User.deleted.delete_all(query)
  end
end
