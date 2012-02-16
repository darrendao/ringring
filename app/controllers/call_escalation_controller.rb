class CallEscalationController < ApplicationController
  def attempt_call
    @numbers = ["8585272359", "6198003326"]
    @number_index = params[:number_index].to_i || 0
    dialCallStatus = params[:DialCallStatus] || ""

    logger.info "number index is #{@number_index}"

    if dialCallStatus != "completed" && @number_index < @numbers.size
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
