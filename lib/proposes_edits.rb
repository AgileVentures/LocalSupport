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

  def editable? field
    publish_field = self.class.publish_proc.call(field)
    if instance_to_edit.respond_to? publish_field
      instance_to_edit.send(publish_field) && self.class.fields_to_edit.include?(field)
    else
      self.class.fields_to_edit.include?(field)
    end
  end

  def has_proposed_edit? field
    instance_to_edit.send(field) != self.send(field)
  end

  module ClassMethods
    attr_reader :klass_to_edit
    attr_reader :fields_to_edit
    attr_reader :publish_proc
    def publish_fields_booleans proc
      @publish_proc = proc
    end
    def proposes_edits_to klass
      @klass_to_edit = klass
    end
    def editable_fields *fields
      @fields_to_edit ||= []
      fields.each{|f| @fields_to_edit.push f}
    end
  end
end
