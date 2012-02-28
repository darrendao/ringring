class CreateTableOncallAssignments < ActiveRecord::Migration
  def up
    create_table :oncall_assignments do |t|
      t.integer :user_id, :null => false
      t.integer :call_list_id, :null => false
      t.integer :position
      t.integer :retry
      t.timestamp
    end
  end

  def down
    drop_table :oncall_assignments
  end
end
