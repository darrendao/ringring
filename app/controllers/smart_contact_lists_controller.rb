class SmartContactListsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :call_list
  load_and_authorize_resource :smart_contact_list, :through => :call_list

  # GET /smart_contact_lists
  # GET /smart_contact_lists.json
  def index
    @smart_contact_lists = SmartContactList.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @smart_contact_lists }
    end
  end

  # GET /smart_contact_lists/1
  # GET /smart_contact_lists/1.json
  def show
    @smart_contact_list = SmartContactList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @smart_contact_list }
    end
  end

  # GET /smart_contact_lists/new
  # GET /smart_contact_lists/new.json
  def new
    @smart_contact_list = SmartContactList.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @smart_contact_list }
    end
  end

  # GET /smart_contact_lists/1/edit
  def edit
    @smart_contact_list = SmartContactList.find(params[:id])
  end

  # POST /smart_contact_lists
  # POST /smart_contact_lists.json
  def create
    @call_list = CallList.find(params[:call_list_id])
    @smart_contact_list = @call_list.smart_contact_lists.build(params[:smart_contact_list])

    respond_to do |format|
      if @smart_contact_list.save
        format.js { render 'update_listing', :layout => false }
        format.html { redirect_to @smart_contact_list, :notice => 'Smart contact list was successfully created.' }
        format.json { render :json => @smart_contact_list, :status => :created, :location => @smart_contact_list }
      else
        format.js { render :partial => 'shared/error', :locals => {:target => @smart_contact_list} }
        format.html { render :action => "new" }
        format.json { render :json => @smart_contact_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /smart_contact_lists/1
  # PUT /smart_contact_lists/1.json
  def update
    @smart_contact_list = SmartContactList.find(params[:id])

    respond_to do |format|
      if @smart_contact_list.update_attributes(params[:smart_contact_list])
        format.html { redirect_to @smart_contact_list, :notice => 'Smart contact list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @smart_contact_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /smart_contact_lists/1
  # DELETE /smart_contact_lists/1.json
  def destroy
    @call_list = CallList.find(params[:call_list_id])
    @smart_contact_list = SmartContactList.find(params[:id])
    @smart_contact_list.destroy

    respond_to do |format|
      format.js { render 'update_listing', :layout => false }
      format.html { redirect_to smart_contact_lists_url }
      format.json { head :no_content }
    end
  end
end
