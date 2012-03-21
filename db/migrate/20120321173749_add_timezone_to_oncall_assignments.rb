class AddTimezoneToOncallAssignments < ActiveRecord::Migration
  def change
    add_column :oncall_assignments, :timezone_offset, :integer
  end
end
