class AddTimeZoneToUser < ActiveRecord::Migration
  #def up
  #  add_column :users, :my_tz, :string
  #  add_column :users, :wtf, :integer
  #end
  #def down
  #  remove_column :users, :wtf
  #  remove_column :users, :my_tz
  #end

  def change
    add_column :users, :time_zone, :string, :default => 'Pacific Time (US & Canada)'
  end
end
