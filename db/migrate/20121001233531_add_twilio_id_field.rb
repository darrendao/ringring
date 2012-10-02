class AddTwilioIdField < ActiveRecord::Migration
  class CallList < ActiveRecord::Base
  end

  def up
    add_column :call_lists, :twilio_list_id, :integer
    CallList.reset_column_information
    CallList.all.each do |call_list|
      call_list.update_attributes!(:twilio_list_id => call_list[:id])
    end
  end

  def down
    remove_column :call_lists, :twilio_list_id
  end
end
