class TwilioCallEscalationsController < ApplicationController
  # FIXME: should only accept requests from twilio
  def attempt_call
    @caller_id = "+16198003326"
    @call_escalations = CallEscalation.all
    @number_index = params[:number_index].to_i || 0
    dialCallStatus = params[:DialCallStatus] || ""

    if dialCallStatus != "completed" && @number_index < @call_escalations.size
      return
    else
      render :text => "<Response><Hangup/></Response>"
    end
  end
  def screen_for_machine
  end
  def complete_call
  end
end
