class ChangeTimeToDatetime < ActiveRecord::Migration
  def up
    change_column :oncall_assignments_gens, :cycle_time, :datetime
    change_column :business_hours, :start_time, :datetime
    change_column :business_hours, :end_time, :datetime
    BusinessHour.where(:start_time => nil, :end_time => nil).destroy_all
  end

  def down
    change_column :business_hours, :end_time, :time
    change_column :business_hours, :start_time, :time
    change_column :oncall_assignments_gens, :cycle_time, :time
  end
end
