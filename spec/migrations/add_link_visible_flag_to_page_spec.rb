require 'rails_helper'

# uses code from http://stackoverflow.com/a/10155232 "How do I test Rails migrations?"
# if you don't name the database columns and tables correctly in your up and down
# methods, this testing approach won't catch it, as it doesn't reverse your up properly
# the alternative approach would be to

migration_file_name = 
  Dir[Rails.root.
      join('db/migrate/*_add_link_visible_flag_to_page.rb')].first
require migration_file_name

ActiveRecord::Migration.verbose = false

describe AddLinkVisibleFlagToPage do

  # This is clearly not very safe or pretty code, and there may be a
  # rails api that handles this. I am just going for a proof of concept here.
  def migration_has_been_run?(version)
    table_name = ActiveRecord::Migrator.schema_migrations_table_name
    query = "SELECT version FROM %s WHERE version = '%s'" % [table_name, version]
    ActiveRecord::Base.connection.execute(query).any?
  end

  let(:migration) { AddLinkVisibleFlagToPage.new }

  before do
    # Hardcoded migration number
    if migration_has_been_run?('20140325182135')
      migration.down
    end
  end

  describe '#up' do
    visibility = { 'about' => true, 'disclaimer' => true, '404' => false }
    it 'adds the link_visible column (even if 404 does not exist)' do
      migration.up;  Page.reset_column_information
      expect(Page.columns_hash).to have_key('link_visible')
    end
    visibility.each do |k,v|
      it "#{k} has link_visible set to #{v}" do
        Page.reset_column_information; seed_some_pages
        migration.up; Page.reset_column_information
        expect(Page.find_by_permalink(k).link_visible).to eq v
      end
    end
  end
end

def seed_some_pages
  Page.create!(:name => "About Us", :permalink => "about")
  Page.create!(:name => "Disclaimer", :permalink => "disclaimer")
  Page.create!(:name => "Custom 404", :permalink => "404")
end

