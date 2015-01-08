module ProposesEdits

  def self.included(base)
    base.extend ClassMethods
  end

  def editable? field
    true
  end

  module ClassMethods
    def proposes_edits_to klass

    end
    def editable_fields *fields

    end
  end
end