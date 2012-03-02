class TwilioErrorNotificationsController < ApplicationController
  def create
    err = params[:err]
    call_list = CallList.find(params[:call_list_id])
    msg = Ringring::CallListErrHandler::generate_error_notifications(err, call_list)

    # build up a response
    response = Twilio::TwiML::Response.new do |r|
      r.Say msg
    end
    render  :text => response.text
  end

  def index
    err = params[:err]
    call_list = CallList.find(params[:call_list_id])
    msg = Ringring::CallListErrHandler::generate_error_notifications(err, call_list)

    # build up a response
    response = Twilio::TwiML::Response.new do |r|
      r.Say msg
    end
    render  :text => response.text
  end
end
