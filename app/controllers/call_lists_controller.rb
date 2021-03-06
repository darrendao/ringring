class CallListsController < ApplicationController
  before_filter :authenticate_user!, :except => ['oncall_email', 'smart_contacts']
  load_and_authorize_resource

  # GET /call_lists
  # GET /call_lists.json
  def index
    @call_lists = CallList.order(:twilio_list_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @call_lists }
    end
  end

  # GET /call_lists/1
  # GET /call_lists/1.json
  def show
    @call_list = CallList.find(params[:id])
    logger.info @call_list.inspect
    logger.info @call_list.call_escalations.inspect

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @call_list }
    end
  end

  # GET /call_lists/new
  # GET /call_lists/new.json
  def new
    @call_list = CallList.new
    call_list_owner = @call_list.call_list_owners.build
    call_list_owner.user_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @call_list }
    end
  end

  # GET /call_lists/1/edit
  def edit
    @call_list = CallList.find(params[:id])
  end

  # POST /call_lists
  # POST /call_lists.json
  def create
    @call_list = CallList.new(params[:call_list])
    params[:call_list][:oncall_assignments_gen_attributes][:enable] = false if params[:call_list][:oncall_assignments_gen_attributes][:enable] == 0
    @call_list.oncall_assignments_gen.cycle_time = Time.zone.parse(params[:call_list][:oncall_assignments_gen_attributes][:cycle_time])

    respond_to do |format|
      if @call_list.save
        format.html { redirect_to @call_list, :notice => 'Call list was successfully created.' }
        format.json { render :json => @call_list, :status => :created, :location => @call_list }
      else
        format.html { render :action => "new" }
        format.json { render :json => @call_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /call_lists/1
  # PUT /call_lists/1.json
  def update
    @call_list = CallList.find(params[:id])
    params[:call_list][:oncall_assignments_gen_attributes][:enable] = false if params[:call_list][:oncall_assignments_gen_attributes][:enable] == 0
    params[:call_list][:oncall_assignments_gen_attributes][:timezone_offset] =  Time.zone.parse(params[:call_list][:oncall_assignments_gen_attributes][:cycle_time]).utc_offset
    params[:call_list][:oncall_assignments_gen_attributes][:cycle_time] = Time.zone.parse(params[:call_list][:oncall_assignments_gen_attributes][:cycle_time])

    old_zone = Time.zone
    params[:call_list][:business_hours_attributes].each do |wday, biz_hr|
      Time.zone = params[:call_list][:business_time_zone]
      biz_hr[:start_time] = Time.zone.parse(biz_hr[:start_time])
      biz_hr[:end_time] = Time.zone.parse(biz_hr[:end_time])
    end
    Time.zone = old_zone

    respond_to do |format|
      if @call_list.update_attributes(params[:call_list])
        format.html { redirect_to @call_list, :notice => 'Call list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @call_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /call_lists/1
  # DELETE /call_lists/1.json
  def destroy
    @call_list = CallList.find(params[:id])
    @call_list.destroy

    respond_to do |format|
      format.html { redirect_to call_lists_url }
      format.json { head :no_content }
    end
  end

  def add_call_escalation
    @call_list = CallList.find(params[:call_list_id])
    user = User.find(params[:user_id])
    call_escalation = CallEscalation.new(:user_id => user.id, :call_list_id => @call_list.id, :retry => params[:retry])
    raise CanCan::AccessDenied unless can? :add_call_escalation, call_escalation
    call_escalation.save
    respond_to do |format|
      format.html
      format.js
    end
  end

  def remove_call_escalation
    @call_list = CallList.find(params[:call_list_id])
    call_escalation = CallEscalation.find(params[:call_escalation_id])
    raise CanCan::AccessDenied unless can? :remove_call_escalation, call_escalation
    call_escalation.destroy
    respond_to do |format|
      format.html { redirect_to @call_list }
      format.json { head :no_content }
    end 
  end

  def pull_oncalls_from_calendar
    oncalls = []
    @call_list = CallList.find(params[:call_list_id])
    err_code = Ringring::Calendar::OncallUpdater::update_oncalls(@call_list)
    unless err_code == Ringring::CallListErrHandler::SUCCESS
      Ringring::CallListErrHandler.notify(err_code, @call_list, AppConfig.error_alerts['oncall_updates'])
    end

    redirect_to @call_list 
  end

  def oncall_email
    call_list = params['call_list']
    if call_list.blank?
      render :text => "Need to specify call_list"
      return
    end

    email = []
    @call_list = CallList.where(:name => call_list).first
    if @call_list.in_business_hours?
      email = @call_list.email
    elsif !@call_list.current_oncalls.empty?
      email = []
      @call_list.current_oncalls.each do |oa|
        email << oa.user.email
        email << oa.user.sms_email
      end
      email = email.join("\n")
    else
      email = []
      @call_list.call_escalations.each do |ce|
        email << ce.user.email
        email << ce.user.sms_email
      end
      email = email.join("\n")
    end   
    render :text => email
  end

  def smart_contacts
    call_list = params['call_list']
    separator = params['separator']
    if call_list.blank?
      render :text => "Need to specify call_list"
      return
    end
    @call_list = CallList.where(:name => call_list).first
    sep_value = "\n" if separator == "newline" || separator.blank?
    sep_value = ","  if separator == "comma"
    sep_value = "\t" if separator == "tab"
    sep_value = "\s" if separator == "space"
    render :text => @call_list.smart_contacts.join(sep_value)
  end

  def download_calendar
    @call_list = CallList.find(params[:call_list_id])
    oncall_assignments = @call_list.oncall_assignments
  
    cal = RiCal.Calendar do
      event do
        description "ops oncall"
        dtstart     Time.zone.parse("3/20/2012 14:47:39")
        dtend       Time.zone.parse("3/21/2012 19:43:02")
      end
    end
    render :text => cal 
  end

  def members_vacations
    vacations = []
    @call_list = CallList.find(params[:id])
    @call_list.members.each do |member|
      vacations |= member.vacations
    end

    respond_to do |format|
      format.js  do
        render :json => vacations
      end
    end
  end

  def gen_oncall_assignments
    @call_list = CallList.find(params[:call_list_id])
    @call_list.gen_oncall_assignments
    redirect_to @call_list
  end
end
