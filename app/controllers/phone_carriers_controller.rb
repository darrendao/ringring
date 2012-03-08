class PhoneCarriersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /phone_carriers
  # GET /phone_carriers.json
  def index
    @phone_carriers = PhoneCarrier.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @phone_carriers }
    end
  end

  # GET /phone_carriers/1
  # GET /phone_carriers/1.json
  def show
    @phone_carrier = PhoneCarrier.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @phone_carrier }
    end
  end

  # GET /phone_carriers/new
  # GET /phone_carriers/new.json
  def new
    @phone_carrier = PhoneCarrier.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @phone_carrier }
    end
  end

  # GET /phone_carriers/1/edit
  def edit
    @phone_carrier = PhoneCarrier.find(params[:id])
  end

  # POST /phone_carriers
  # POST /phone_carriers.json
  def create
    @phone_carrier = PhoneCarrier.new(params[:phone_carrier])

    respond_to do |format|
      if @phone_carrier.save
        format.html { redirect_to @phone_carrier, :notice => 'Phone carrier was successfully created.' }
        format.json { render :json => @phone_carrier, :status => :created, :location => @phone_carrier }
      else
        format.html { render :action => "new" }
        format.json { render :json => @phone_carrier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /phone_carriers/1
  # PUT /phone_carriers/1.json
  def update
    @phone_carrier = PhoneCarrier.find(params[:id])

    respond_to do |format|
      if @phone_carrier.update_attributes(params[:phone_carrier])
        format.html { redirect_to @phone_carrier, :notice => 'Phone carrier was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @phone_carrier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /phone_carriers/1
  # DELETE /phone_carriers/1.json
  def destroy
    @phone_carrier = PhoneCarrier.find(params[:id])
    @phone_carrier.destroy

    respond_to do |format|
      format.html { redirect_to phone_carriers_url }
      format.json { head :no_content }
    end
  end
end
