module Permissions
  module User
    extend ActiveSupport::Concern

    def can_edit?(org)
      superadmin? || (!org.nil? && organisation == org)
    end

    def can_delete?
      superadmin?
    end

    def can_request_org_admin?(org)
      !superadmin? && (organisation != org) && (pending_organisation != org)
    end

    def belongs_to?(org)
      organisation == org
    end

    def can_create_volunteer_ops?(org)
      belongs_to?(org) || superadmin?
    end

    def pending_org_admin?(org)
      return false if pending_organisation.nil?
      pending_organisation == org
    end
  end
end
