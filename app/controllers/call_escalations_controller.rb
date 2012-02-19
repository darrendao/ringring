class CallEscalationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /call_escalations
  # GET /call_escalations.json
  def index
    @call_escalations = CallEscalation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @call_escalations }
    end
  end

  # GET /call_escalations/1
  # GET /call_escalations/1.json
  def show
    @call_escalation = CallEscalation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @call_escalation }
    end
  end

  # GET /call_escalations/new
  # GET /call_escalations/new.json
  def new
    @call_escalation = CallEscalation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @call_escalation }
    end
  end

  # GET /call_escalations/1/edit
  def edit
    @call_escalation = CallEscalation.find(params[:id])
  end

  # POST /call_escalations
  # POST /call_escalations.json
  def create
    @call_escalation = CallEscalation.new(params[:call_escalation])

    respond_to do |format|
      if @call_escalation.save
        format.html { redirect_to @call_escalation, :notice => 'Call escalation was successfully created.' }
        format.json { render :json => @call_escalation, :status => :created, :location => @call_escalation }
      else
        format.html { render :action => "new" }
        format.json { render :json => @call_escalation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /call_escalations/1
  # PUT /call_escalations/1.json
  def update
    @call_escalation = CallEscalation.find(params[:id])

    respond_to do |format|
      if @call_escalation.update_attributes(params[:call_escalation])
        format.html { redirect_to @call_escalation, :notice => 'Call escalation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @call_escalation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /call_escalations/1
  # DELETE /call_escalations/1.json
  def destroy
    @call_escalation = CallEscalation.find(params[:id])
    @call_escalation.destroy

    respond_to do |format|
      format.html { redirect_to call_escalations_url }
      format.json { head :no_content }
    end
  end

  def sort
    @call_escalations = CallEscalation.all
    @call_escalations.each do |call_escalation|
      call_escalation.position = params['call_escalation'].index(call_escalation.id.to_s) + 1
      call_escalation.save
    end
    render :nothing => true
  end

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
