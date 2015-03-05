module ProposesEdits

  def self.included(base)
    base.extend ClassMethods
  end

  def instance_to_edit
    @instance_to_edit ||=
      self.send(self.class.klass_to_edit)
  end

  def accept params
    instance_to_edit.update(params)
    update!(:accepted => true, :archived => true)
  end

  def non_published_generally_editable_fields
    self.class.fields_to_edit.select{|f| !editable?(f)}
  end

  def viewable_field? field, opts = {}
    editable?(field) || can_user_view_non_public_fields?(opts[:by])

  end
  def editable? field, opts = {}
    editable = self.class.fields_to_edit.include?(field)
    editable &= can_user_edit_this_field_if_private? self.class.publish_proc.call(field), opts[:by]
    editable
  end

  def has_proposed_edit? field
    instance_to_edit.send(field) != self.send(field)
  end
  private 
  def can_user_view_non_public_fields? usr
    self.class.user_types_who_view_non_public_fields.any?{|u| usr.try(u)} 
  end
  def can_user_edit_this_field_if_private? publish_field, usr
    return true unless instance_to_edit.respond_to? publish_field
    is_public = instance_to_edit.send(publish_field)
    user_can_edit_private_fields = usr.try(self.class.user_type_who_edits_non_public_fields)
    is_public || user_can_edit_private_fields  
  end

  module ClassMethods
    attr_reader :klass_to_edit
    attr_reader :fields_to_edit
    attr_reader :publish_proc
    attr_reader :user_type_who_edits_non_public_fields
    attr_reader :user_types_who_view_non_public_fields
    def publish_fields_booleans proc
      @publish_proc = proc
    end
    def proposes_edits_to klass
      @klass_to_edit = klass
    end
    def non_public_fields_editable_by usr_type
      @user_type_who_edits_non_public_fields = usr_type
    end
    def non_public_fields_viewable_by *args
      @user_types_who_view_non_public_fields ||= []
      args.each{|u| @user_types_who_view_non_public_fields.push u}
    end
    def editable_fields *fields
      @fields_to_edit ||= []
      fields.each{|f| @fields_to_edit.push f}
    end
  end
end
