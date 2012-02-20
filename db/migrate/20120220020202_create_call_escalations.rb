class CreateCallEscalations < ActiveRecord::Migration
  def up
    create_table :call_escalations do |t|
      t.integer :user_id, :null => false
      t.integer :position
    end
  end

  def down
    drop_table :call_escalations
  end
end
