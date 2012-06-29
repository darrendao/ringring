class AddTimezoneOffsetToOncallAssignmentsGen < ActiveRecord::Migration
  def change
    add_column :oncall_assignments_gens, :timezone_offset, :integer

  end
end
