class CreateClickThroughs < ActiveRecord::Migration
  def up
    create_table :click_throughs do |t|
      t.string 'url'
      t.string 'source_url'
      t.string 'user_id', :null => true
       t.timestamps
    end
  end

  def down
    drop_table :click_throughs
  end
end
