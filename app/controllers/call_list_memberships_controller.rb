class CallListMembershipsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :call_list
  load_and_authorize_resource :call_list_membership, :through => :call_list

  # GET /call_list_memberships
  # GET /call_list_memberships.json
  def index
    @call_list_memberships = CallListMembership.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @call_list_memberships }
    end
  end

  # GET /call_list_memberships/1
  # GET /call_list_memberships/1.json
  def show
    @call_list_membership = CallListMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @call_list_membership }
    end
  end

  # GET /call_list_memberships/new
  # GET /call_list_memberships/new.json
  def new
    @call_list_membership = CallListMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @call_list_membership }
    end
  end

  # GET /call_list_memberships/1/edit
  def edit
    @call_list_membership = CallListMembership.find(params[:id])
  end

  # POST /call_list_memberships
  # POST /call_list_memberships.json
  def create
    @call_list = CallList.find(params[:call_list_id])
    params[:call_list_membership][:oncall_candidate] = false if params[:call_list_membership][:oncall_candidate] == 0
    @call_list_membership = @call_list.call_list_memberships.build(params[:call_list_membership])

    respond_to do |format|
      if @call_list_membership.save
        format.js { render 'update_listing', :layout => false }
        format.html { redirect_to @call_list_membership, :notice => 'Call list membership was successfully created.' }
        format.json { render :json => @call_list_membership, :status => :created, :location => @call_list_membership }
      else
        format.js { render :partial => 'shared/error', :locals => {:target => @call_list_membership} }
        format.html { render :action => "new" }
        format.json { render :json => @call_list_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /call_list_memberships/1
  # PUT /call_list_memberships/1.json
  def update
    @call_list_membership = CallListMembership.find(params[:id])
    params[:call_list_membership][:oncall_candidate] = false if params[:call_list_membership][:oncall_candidate] == 0

    respond_to do |format|
      if @call_list_membership.update_attributes(params[:call_list_membership])
        format.html { redirect_to @call_list_membership, :notice => 'Call list membership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @call_list_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /call_list_memberships/1
  # DELETE /call_list_memberships/1.json
  def destroy
    @call_list = CallList.find(params[:call_list_id])
    @call_list_membership = CallListMembership.find(params[:id])
    @call_list_membership.destroy

    respond_to do |format|
      format.js { render 'update_listing', :layout => false }
      format.html { redirect_to call_list_memberships_url }
      format.json { head :no_content }
    end
  end

  def sort
    @call_list_memberships = CallListMembership.all
    @call_list_memberships.each do |call_list_membership|
      next if params['call_list_membership'].index(call_list_membership.id.to_s).nil?
      unless can? :sort, call_list_membership
        raise "Bad user"
      end
      call_list_membership.position = params['call_list_membership'].index(call_list_membership.id.to_s) + 1
      call_list_membership.save
    end
    render :nothing => true
  end
end
