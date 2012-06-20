class AddSmsEmailToUser < ActiveRecord::Migration
  def up
    sms_emails = {}
    User.all.each do |user|
      sms_emails[user.id] = user.old_sms_email
    end
    add_column :users, :sms_email, :string
    User.all.each do |user|
      user.sms_email = sms_emails[user.id]
      user.save
    end
  end
  def down
    remove_column :users, :sms_email
  end
end
