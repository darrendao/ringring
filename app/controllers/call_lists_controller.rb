class CallListsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /call_lists
  # GET /call_lists.json
  def index
    @call_lists = CallList.all

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

end
