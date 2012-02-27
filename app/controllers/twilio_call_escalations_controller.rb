class TwilioCallEscalationsController < ApplicationController
  before_filter :force_ssl if AppConfig.use_ssl

  # FIXME: should only accept requests from twilio
  def attempt_call
    @base_url = AppConfig.base_url || ""
    @call_list = CallList.find(params[:call_list_id])
    @caller_id = "+16198003326"
    @call_escalations = @call_list.call_escalations
    @number_index = params[:number_index].to_i || 0
    dialCallStatus = params[:DialCallStatus] || ""

    if dialCallStatus != "completed" && @number_index < @call_escalations.size
      return
    else
      render :text => "<Response><Hangup/></Response>"
    end
  end
  def screen_for_machine
    @base_url = AppConfig.base_url || ""
    @machine_detection_wait_time = AppConfig.machine_detection_wait_time || 15
  end
  def complete_call
    @base_url = AppConfig.base_url || ""
  end
end
