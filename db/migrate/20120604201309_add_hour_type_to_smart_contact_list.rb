class AddHourTypeToSmartContactList < ActiveRecord::Migration
  def change
    add_column :smart_contact_lists, :hour_type, :string

  end
end
