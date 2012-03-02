class CreateErrorNotifications < ActiveRecord::Migration
  def change
    create_table :error_notifications do |t|
      t.integer :notifiable_id
      t.string :notifiable_type
      t.datetime :last_notified
    end
  end
end
