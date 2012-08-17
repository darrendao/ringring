class AddTimezoneOffsetToBusinessHours < ActiveRecord::Migration
  def change
    add_column :business_hours, :timezone_offset, :integer

  end
end
