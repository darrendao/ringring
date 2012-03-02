class ErrorNotifier < ActionMailer::Base
  default :from => AppConfig.admin_email
  def no_oncall(call_list)
    @call_list = call_list
    mail_to = []
    @call_list.notification_users.each do |owner|
      next if owner.email.blank?
      mail_to << owner.email
    end
    mail(:to => mail_to, :subject => "Oncall list is empty")
  end

  def unknown_oncall_users(call_list)
    @call_list = call_list
    mail_to = []
    @call_list.notification_users.each do |owner|
      next if owner.email.blank?
      mail_to << owner.email
    end
    mail(:to => mail_to, :subject => "Unknown user(s) from oncall calendar")
  end

  def fetch_calendar_err(call_list)
    @call_list = call_list
    mail_to = []
    @call_list.notification_users.each do |owner|
      next if owner.email.blank?
      mail_to << owner.email
    end
    mail(:to => mail_to, :subject => "Failed to fetch oncall assignments from calendar")
  end
end
