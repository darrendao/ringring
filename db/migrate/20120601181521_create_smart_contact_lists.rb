class CreateSmartContactLists < ActiveRecord::Migration
  def change
    create_table :smart_contact_lists do |t|
      t.integer :call_list_id
      t.string :contact_type

      t.timestamps
    end
  end
end
