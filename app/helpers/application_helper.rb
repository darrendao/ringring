module ApplicationHelper
  def jquery_ui_button_icon(text, icon, id)
    "<button class='ui-button ui-button-text-icon-primary' id='#{id}'><span class='ui-button-icon-primary ui-icon #{icon}'></span><span class='ui-button-text'>#{text}</span></button>"
  end
  def day_options
    day_options = []
    Date::ABBR_DAYNAMES.each_with_index do|x,y|
      day_options << [x, y]
    end
    day_options
  end
  def fmt_time(time)
    time ? l(time, :format => :timeonly) : ""
  end  
end
