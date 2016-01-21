class CreateProposedOrganisationEdit

  def self.with(listener, params, model_klass = ProposedOrganisationEdit, user_klass = User, mailer_klass = AdminMailer)
    new(listener, params, model_klass, user_klass, mailer_klass).send(:run)
  end

  private

  attr_reader :listener, :params, :organisation, :model_klass, :user_klass, :mailer_klass, :editor

  def initialize(listener, params, model_klass, user_klass, mailer_klass)
    @listener = listener
    @params = params
    @organisation = params[:organisation]
    @editor = params[:editor]
    @model_klass = model_klass
    @user_klass = user_klass
    @mailer_klass = mailer_klass
  end

  def run
    unless editor.siteadmin?
      merge_in_non_published_fields
      send_email_to_superadmin_about_org_edit
      listener.set_notice('Edit is pending admin approval.')
    end
    model_klass.create(params)
  end

  def merge_in_non_published_fields
    in_memory_edit = ProposedOrganisationEdit.new(organisation: organisation)
    in_memory_edit.non_published_generally_editable_fields.each do |non_published_field|
      params.merge!(non_published_field => organisation.send(non_published_field))
    end
  end

  def send_email_to_superadmin_about_org_edit
    superadmin_emails = user_klass.superadmins.pluck(:email)
    mailer_klass.edit_org_waiting_for_approval(organisation, superadmin_emails).deliver_now
  end
end
