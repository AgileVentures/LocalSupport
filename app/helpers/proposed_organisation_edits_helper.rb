module ProposedOrganisationEditsHelper

  def show_class(mode, attr)
    classes = [mode + '_organisation_' + attr]
    if @proposed_organisation_edit.has_proposed_edit?(attr.to_sym)
      classes << (mode == 'current' ? 'current_value' : 'proposed_value')
    end
    classes.join(' ')
  end

end
