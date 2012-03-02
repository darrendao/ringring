CallList.all.each do |call_list|
  next if call_list.call_list_calendar.nil? or call_list.call_list_calendar.url.blank?

  err_code = Ringring::Calendar::OncallUpdater::update_oncalls(call_list)
  puts "#{call_list.name} --- #{call_list.call_list_calendar.url} --- #{err_code}"
  unless err_code == Ringring::CallListErrHandler::SUCCESS
    Ringring::CallListErrHandler.notify(err_code, call_list, AppConfig.error_alerts['oncall_updates'])
  end
end
