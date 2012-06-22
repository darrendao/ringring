class AddTimezoneOffsetToVacation < ActiveRecord::Migration
  def change
    add_column :vacations, :timezone_offset, :integer

  end
end
