class CreateBusinessHours < ActiveRecord::Migration
  def change
    create_table :business_hours do |t|
      t.integer :call_list_id
      t.integer :wday
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
