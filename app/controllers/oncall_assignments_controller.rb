class OncallAssignmentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :call_list
  load_and_authorize_resource :oncall_assignment, :through => :call_list
#  load_and_authorize_resource

  def index
    @oncall_assignments = CallList.find(params[:call_list_id]).oncall_assignments
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @oncall_assignments }
      format.html # index.html.erb
      format.js  do
        logger.info @oncall_assignments
        render :json => @oncall_assignments 
      end
    end
  end
  
  def create
    @gotodate = Time.zone.parse(params[:oncall_assignment][:starts_at]).to_time.to_i * 1000

    set_tz_offset
    @call_list = CallList.find(params[:call_list_id])
    @oncall_assignment = @call_list.oncall_assignments.build(params[:oncall_assignment]) 
    @oncall_assignment.assigned_by = current_user.username
    respond_to do |format|
      if @oncall_assignment.save
        logger.info "#{current_user.username} creates #{@oncall_assignment.inspect}"
        format.js { render 'update_listing', :layout => false }
      else
        format.js { render :partial => 'shared/error', :locals => {:target => @oncall_assignment} }
      end
    end
  end

  def destroy
    @call_list = CallList.find(params[:call_list_id])
    oncall_assignment = OncallAssignment.find(params[:id])
    @gotodate = oncall_assignment.starts_at.to_time.to_i * 1000
    logger.info "#{current_user.username} deletes #{oncall_assignment.inspect}"
    oncall_assignment.destroy
    respond_to do |format|
      format.html do
        redirect_to :back
      end
      format.js { render 'update_listing', :layout => false }
    end
  end

  def show
    @oncall_assignment = OncallAssignment.find(params[:id])
    if request.xhr?
      render 'show', :layout => false 
      return
    end
  end

  # PUT /oncall_assignments/1
  # PUT /oncall_assignments/1.xml
  # PUT /oncall_assignments/1.js
  # when we drag an event on the calendar (from day to day on the month view, or stretching
  # it on the week or day view), this method will be called to update the values.
  # viv la REST!
  def update
    @gotodate = Time.zone.parse(params[:oncall_assignment][:starts_at]).to_time.to_i * 1000

    set_tz_offset
    @oncall_assignment = OncallAssignment.find(params[:id])
    if params[:oncall_assignment]
      if [:oncall]
        user_id = User.where(:username => params[:oncall]).first
        params[:oncall_assignment][:user_id] = user_id.id if user_id
        params[:oncall_assignment].delete(:oncall)
      end
      params[:oncall_assignment][:starts_at] = Time.zone.parse(params[:oncall_assignment][:starts_at].to_s) if params[:oncall_assignment][:starts_at]
      params[:oncall_assignment][:ends_at] = Time.zone.parse(params[:oncall_assignment][:ends_at].to_s) if params[:oncall_assignment][:ends_at]
    end
    params[:oncall_assignment][:assigned_by] = current_user.username

    respond_to do |format|
      if @oncall_assignment.update_attributes(params[:oncall_assignment])
        logger.info "#{current_user.username} updates #{@oncall_assignment.inspect}"
        @call_list = CallList.find(params[:call_list_id])
        format.html { redirect_to(@oncall_assignment, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
        format.js { 
          render 'update_listing', :layout => false 
        }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @oncall_assignment.errors, :status => :unprocessable_entity }
        format.js  { render :js => @oncall_assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def deprecated_refresh_listing
    @call_list = CallList.find(params[:call_list_id])
    render 'update_listing', :layout => false
  end

  private
  def set_tz_offset
    if params[:oncall_assignment] && params[:oncall_assignment][:starts_at]
      params[:oncall_assignment][:timezone_offset] = Time.zone.parse(params[:oncall_assignment][:starts_at]).utc_offset
    end 
  end
end
