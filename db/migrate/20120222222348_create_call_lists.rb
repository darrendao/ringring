class CreateCallLists < ActiveRecord::Migration
  def change
    create_table :call_lists do |t|
      t.string :name

      t.timestamps
    end
  end
end
