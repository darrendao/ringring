class RemovePhoneNumberFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :phone_number
  end

  def down
    add_column :users, :phone_number, :string
  end
end
