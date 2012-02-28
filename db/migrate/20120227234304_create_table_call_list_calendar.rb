class CreateTableCallListCalendar < ActiveRecord::Migration
  def change
    create_table :call_list_calendars do |t|
      t.string :url
      t.integer :call_list_id
      t.string :ctype
      t.timestamps
    end
  end
end
