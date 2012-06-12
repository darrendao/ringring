class TwilioCallEscalationsController < ApplicationController
  before_filter :force_ssl if AppConfig.use_ssl

  # FIXME: should only accept requests from twilio
  def attempt_call
    @base_url = AppConfig.base_url || ""
    @call_list = CallList.find(params[:call_list_id])
    @call_escalations = [@call_list.current_oncalls, @call_list.call_escalations].flatten
    @number_index = params[:number_index].to_i || 0
    @try = (params[:try] || 1).to_i
    dialCallStatus = params[:DialCallStatus] || ""

    @call_escalation = get_number_to_call

    if dialCallStatus != "completed" && @call_escalation
      return
    elsif dialCallStatus == "completed"
      render :text => "<Response><Hangup/></Response>"
    else
      render :text => "<Response><Say>No one on the call list pick up their phone. Good bye.</Say><Hangup/></Response>"
    end
  end
  def screen_for_machine
    @base_url = AppConfig.base_url || ""
    @machine_detection_wait_time = AppConfig.machine_detection_wait_time || 15
  end
  def complete_call
    @base_url = AppConfig.base_url || ""
  end

  private
  def get_number_to_call
    unless @call_escalations[@number_index]
      return nil
    end
    call_escalation = @call_escalations[@number_index]
    if @try > call_escalation.retry
      @number_index += 1
      @try = 1
      call_escalation = @call_escalations[@number_index]
    end
    @try += 1
    return call_escalation
  end
end
