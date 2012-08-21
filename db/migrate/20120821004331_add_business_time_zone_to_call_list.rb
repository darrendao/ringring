class AddBusinessTimeZoneToCallList < ActiveRecord::Migration
  def up
    add_column :call_lists, :business_time_zone, :string
    CallList.all.each do |call_list|
      call_list.business_time_zone = 'Pacific Time (US & Canada)'
      call_list.save
    end
  end
  def down
    remove_column :call_lists, :business_time_zone

  end
end
