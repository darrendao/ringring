class AddStartEndTimeToOncallAssignments < ActiveRecord::Migration
  def change
    add_column :oncall_assignments, :starts_at, :datetime
    add_column :oncall_assignments, :ends_at, :datetime
  end
end
