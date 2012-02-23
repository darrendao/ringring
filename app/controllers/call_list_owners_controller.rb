class CallListOwnersController < ApplicationController
  # GET /call_list_owners
  # GET /call_list_owners.json
  def index
    @call_list_owners = CallListOwner.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @call_list_owners }
    end
  end

  # GET /call_list_owners/1
  # GET /call_list_owners/1.json
  def show
    @call_list_owner = CallListOwner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @call_list_owner }
    end
  end

  # GET /call_list_owners/new
  # GET /call_list_owners/new.json
  def new
    @call_list_owner = CallListOwner.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @call_list_owner }
    end
  end

  # GET /call_list_owners/1/edit
  def edit
    @call_list_owner = CallListOwner.find(params[:id])
  end

  # POST /call_list_owners
  # POST /call_list_owners.json
  def create
    @call_list_owner = CallListOwner.new(params[:call_list_owner])

    respond_to do |format|
      if @call_list_owner.save
        format.html { redirect_to @call_list_owner, :notice => 'Call list owner was successfully created.' }
        format.json { render :json => @call_list_owner, :status => :created, :location => @call_list_owner }
      else
        format.html { render :action => "new" }
        format.json { render :json => @call_list_owner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /call_list_owners/1
  # PUT /call_list_owners/1.json
  def update
    @call_list_owner = CallListOwner.find(params[:id])

    respond_to do |format|
      if @call_list_owner.update_attributes(params[:call_list_owner])
        format.html { redirect_to @call_list_owner, :notice => 'Call list owner was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @call_list_owner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /call_list_owners/1
  # DELETE /call_list_owners/1.json
  def destroy
    @call_list_owner = CallListOwner.find(params[:id])
    @call_list_owner.destroy

    respond_to do |format|
      format.html { redirect_to call_list_owners_url }
      format.json { head :no_content }
    end
  end
end
