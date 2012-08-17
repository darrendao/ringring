class ChangeTimeToDatetime < ActiveRecord::Migration
  def up
    change_column :oncall_assignments_gens, :cycle_time, :datetime
    change_column :business_hours, :start_time, :datetime
    change_column :business_hours, :end_time, :datetime
    BusinessHour.where(:start_time => nil, :end_time => nil).destroy_all
    BusinessHour.all.each do |biz_hr|
      start_time = Time.parse(biz_hr.start_time.strftime('%T %p'))
      end_time = Time.parse(biz_hr.end_time.strftime('%T %p'))
      biz_hr.start_time = start_time
      biz_hr.end_time = end_time
      biz_hr.save
    end
    OncallAssignmentsGen.all.each do |oag|
      oag.cycle_time = Time.parse(oag.cycle_time.strftime('%T %p'))
      oag.save
    end
  end

  def down
    change_column :business_hours, :end_time, :time
    change_column :business_hours, :start_time, :time
    change_column :oncall_assignments_gens, :cycle_time, :time
  end
end
