class CallEscalationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :call_list
  load_and_authorize_resource :call_escalation, :through => :call_list
#  load_and_authorize_resource

  def create
    @call_list = CallList.find(params[:call_list_id])
    @call_escalation = @call_list.call_escalations.build(params[:call_escalation])
    respond_to do |format|
      if @call_escalation.save
        format.js { render 'update_listing', :layout => false }
      else
        format.js { render :partial => 'shared/error', :locals => {:target => @call_escalation} }
      end
    end
  end

  def destroy
    @call_list = CallList.find(params[:call_list_id])
    CallEscalation.find(params[:id]).destroy
    respond_to do |format|
      format.js { render 'update_listing', :layout => false }
    end
  end

  def sort
    @call_escalations = CallEscalation.all
    @call_escalations.each do |call_escalation|
      next if params['call_escalation'].index(call_escalation.id.to_s).nil?
      unless can? :sort, call_escalation
        raise "Bad user"
      end
      call_escalation.position = params['call_escalation'].index(call_escalation.id.to_s) + 1
      call_escalation.save
    end
    render :nothing => true
  end
end
