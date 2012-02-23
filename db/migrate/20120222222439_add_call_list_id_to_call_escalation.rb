class AddCallListIdToCallEscalation < ActiveRecord::Migration
  def change
    add_column :call_escalations, :call_list_id, :integer
  end
end
