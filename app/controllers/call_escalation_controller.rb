class CallEscalationController < ApplicationController
  def attempt_call
    numbers = ["8585272359", "6198003326"]
    number_index = params[:number_index] || 0
    dialCallStatus = params[:DialCallStatus] || ""

    #if dialCallStatus != "completed" && number_index < numbers.size
    #else
    #end 
  end
  def hello_world
  end
  def screen_for_machine
  end
  def complete_call
  end
end
