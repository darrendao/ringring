class OncallAssignmentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :call_list
  load_and_authorize_resource :oncall_assignment, :through => :call_list
#  load_and_authorize_resource
  
  def create
    @call_list = CallList.find(params[:call_list_id])
    @oncall_assignment = @call_list.oncall_assignments.build(params[:oncall_assignment]) 
    respond_to do |format|
      if @oncall_assignment.save
        format.js { render 'update_listing', :layout => false }
      else
        format.js { render :partial => 'shared/error', :locals => {:target => @oncall_assignment} }
      end
    end
  end

  def destroy
    @call_list = CallList.find(params[:call_list_id])
    OncallAssignment.find(params[:id]).destroy
    respond_to do |format|
      format.js { render 'update_listing', :layout => false }
    end
  end
end
