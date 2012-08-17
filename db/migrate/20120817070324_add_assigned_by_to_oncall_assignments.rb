class AddAssignedByToOncallAssignments < ActiveRecord::Migration
  def change
    add_column :oncall_assignments, :assigned_by, :string
  end
end
