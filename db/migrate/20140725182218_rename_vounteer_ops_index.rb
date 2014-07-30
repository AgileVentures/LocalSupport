class RenameVounteerOpsIndex < ActiveRecord::Migration
  rename_index :volunteer_ops, :index_volunteer_ops_on_organization_id, :index_volunteer_ops_on_organisation_id
end
