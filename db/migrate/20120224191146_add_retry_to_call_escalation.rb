class AddRetryToCallEscalation < ActiveRecord::Migration
  def change
    add_column :call_escalations, :retry, :integer, :default => 2
  end
end
