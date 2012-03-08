class PhoneNumberInfosController < ApplicationController
  # GET /phone_number_infos
  # GET /phone_number_infos.json
  def index
    @phone_number_infos = PhoneNumberInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @phone_number_infos }
    end
  end

  # GET /phone_number_infos/1
  # GET /phone_number_infos/1.json
  def show
    @phone_number_info = PhoneNumberInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @phone_number_info }
    end
  end

  # GET /phone_number_infos/new
  # GET /phone_number_infos/new.json
  def new
    @phone_number_info = PhoneNumberInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @phone_number_info }
    end
  end

  # GET /phone_number_infos/1/edit
  def edit
    @phone_number_info = PhoneNumberInfo.find(params[:id])
  end

  # POST /phone_number_infos
  # POST /phone_number_infos.json
  def create
    @phone_number_info = PhoneNumberInfo.new(params[:phone_number_info])

    respond_to do |format|
      if @phone_number_info.save
        format.html { redirect_to @phone_number_info, :notice => 'Phone number info was successfully created.' }
        format.json { render :json => @phone_number_info, :status => :created, :location => @phone_number_info }
      else
        format.html { render :action => "new" }
        format.json { render :json => @phone_number_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /phone_number_infos/1
  # PUT /phone_number_infos/1.json
  def update
    @phone_number_info = PhoneNumberInfo.find(params[:id])

    respond_to do |format|
      if @phone_number_info.update_attributes(params[:phone_number_info])
        format.html { redirect_to @phone_number_info, :notice => 'Phone number info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @phone_number_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /phone_number_infos/1
  # DELETE /phone_number_infos/1.json
  def destroy
    @phone_number_info = PhoneNumberInfo.find(params[:id])
    @phone_number_info.destroy

    respond_to do |format|
      format.html { redirect_to phone_number_infos_url }
      format.json { head :no_content }
    end
  end
end
