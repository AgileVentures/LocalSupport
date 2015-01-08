module ProposesEdits

  def self.included(base)
    base.extend ClassMethods
  end

  def editable? field
    publish_field = ('publish_' + field.to_s).to_sym
    instance_to_edit = self.send(self.class.klass_to_edit)
    if instance_to_edit.respond_to? publish_field
      instance_to_edit.send(publish_field) && self.class.fields_to_edit.include?(field)
    else
      self.class.fields_to_edit.include?(field)
    end
  end

  module ClassMethods
    attr_reader :klass_to_edit
    attr_reader :fields_to_edit
    def proposes_edits_to klass
      @klass_to_edit = klass
    end
    def editable_fields *fields
      @fields_to_edit ||= []
      fields.each{|f| @fields_to_edit.push f}
    end
  end
end