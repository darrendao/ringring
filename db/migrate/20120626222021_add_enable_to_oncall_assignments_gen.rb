class AddEnableToOncallAssignmentsGen < ActiveRecord::Migration
  def change
    add_column :oncall_assignments_gens, :enable, :boolean

  end
end
