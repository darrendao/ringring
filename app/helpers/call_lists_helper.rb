module CallListsHelper
  def setup_call_list(call_list)
    limit = 2 - call_list.call_list_owners.size
    (0..limit).each do |i|
      call_list.call_list_owners.build
    end

    call_list.call_list_calendar ||= CallListCalendar.new

    existing = []
    call_list.business_hours.each do |i|
      existing << i.wday
    end
    (0..6).each do |i|
      next if existing.include? i
      business_hour = call_list.business_hours.build(:wday => i)
      if business_hour.wday != Date::ABBR_DAYNAMES.index('Sun') and business_hour.wday != Date::ABBR_DAYNAMES.index('Sat')
        business_hour.start_time ||= Time.parse(AppConfig.business_hours[0])
        business_hour.end_time ||= Time.parse(AppConfig.business_hours[1])
      end
    end
    call_list.business_hours.sort!{|x,y| x.wday <=> y.wday}    

    return call_list
  end

  def display_calendar_link
    if @call_list.call_list_calendar && !@call_list.call_list_calendar.url.blank? 
      link_to(@call_list.call_list_calendar.url, @call_list.call_list_calendar.url)
    else
      "N/A"
    end
  end

  def oncall_assignment_options
    all_users = User.order('username').collect {|s| ["#{s.username} | #{s.first_name} #{s.last_name}", s.id]}
    members = @call_list.members.order('username').collect {|s| ["#{s.username} | #{s.first_name} #{s.last_name}", s.id]}
    non_members = all_users - members
    options_for_select(members | ["-----------------------", nil] | non_members)
  end
end
