class PopulateSmsEmailField < ActiveRecord::Migration
  def up
    sms_emails = {}
    User.all.each do |user|
      sms_emails[user.id] = user.old_sms_email
      user.sms_email = sms_emails[user.id]
      user.save
    end
  end

  def down
  end
end
