module ApplicationHelper
  def jquery_ui_button_icon(text, icon, id)
    "<button class='ui-button ui-button-text-icon-primary' id='#{id}'><span class='ui-button-icon-primary ui-icon #{icon}'></span><span class='ui-button-text'>#{text}</span></button>"
  end
end
