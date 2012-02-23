class CreateCallListOwners < ActiveRecord::Migration
  def change
    create_table :call_list_owners do |t|
      t.integer :call_list_id
      t.integer :user_id

      t.timestamps
    end
  end
end
