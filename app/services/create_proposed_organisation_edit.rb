class CreateProposedOrganisationEdit

  def self.with(listener: listener, params: params)
    unless params[:editor].siteadmin?
      merge_in_non_published_fields params[:organisation], params
      send_email_to_superadmin_about_org_edit params[:organisation]
      listener.flash[:notice] = "Edit is pending admin approval."
    end
    ProposedOrganisationEdit.create(params)
  end

  private

  def self.merge_in_non_published_fields(org, params)
    in_memory_edit = ProposedOrganisationEdit.new(organisation: org)
    in_memory_edit.non_published_generally_editable_fields.each do |non_published_field|
      params.merge!(non_published_field => org.send(non_published_field))
    end
  end

  def self.send_email_to_superadmin_about_org_edit(org)
    superadmin_emails = User.superadmins.pluck(:email)
    AdminMailer.edit_org_waiting_for_approval(org, superadmin_emails).deliver_now
  end
end
