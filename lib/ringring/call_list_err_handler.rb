module Ringring
module CallListErrHandler
  SUCCESS = 0
  FETCH_CALENDAR_ERR = 1
  NO_ONCALL = 2
  UNKNOWN_ONCALL_USER = 3

  def self.notify(err, call_list, notify_flags)
    if call_list.error_notification.nil?
      call_list.error_notification = ErrorNotification.create(:last_notified => DateTime.now)
    elsif call_list.error_notification.last_notified.nil? or call_list.error_notification.last_notified < AppConfig.error_alerts['thresh_hold'].minutes.ago
      call_list.error_notification.last_notified = DateTime.now
      call_list.error_notification.save
    else
      return
    end

    # Here we're making a lot of assumption about how we name our
    # method. That's how we map from the error to the actual notification 
    # methods to invoke
    err_mapping = nil
    case err
    when NO_ONCALL
      err_mapping = "no_oncall"
    when UNKNOWN_ONCALL_USER
      err_mapping = "unknown_oncall_users"
    when FETCH_CALENDAR_ERR
      err_mapping = "fetch_calendar_err"
    end

    msg = generate_error_notifications(err_mapping, call_list)
    url = File.join(AppConfig.base_url, "twilio_error_notifications?err=#{err_mapping}&call_list_id=#{call_list.id}")
    send_to = call_list.notification_users.map{|user| user.phone_number}

    ErrorNotifier.send(err_mapping, call_list).deliver if notify_flags['email']
    TwilioHelper::send_sms(AppConfig.caller_id, send_to, msg) if notify_flags['sms']
    TwilioHelper::phone_all(AppConfig.caller_id, send_to, url) if notify_flags['phone']
  end

  def self.generate_error_notifications(err, call_list)
    I18n.t("error_notifications." + err).gsub("__CALL_LIST_NAME__", call_list.name)
  end
end
end
