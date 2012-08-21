class RemoveTimezoneOffsetFromBusinessHour < ActiveRecord::Migration
  def up
    remove_column :business_hours, :timezone_offset
  end

  def down
    add_column :business_hours, :timezone_offset, :integer
  end
end
