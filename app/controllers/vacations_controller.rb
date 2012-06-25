class VacationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :user
  load_and_authorize_resource :vacation, :through => :user

  # GET /vacations
  # GET /vacations.json
  def index
    @vacations = User.find(params[:user_id]).vacations 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @vacations }
    end
  end

  # GET /vacations/1
  # GET /vacations/1.json
  def show
    @vacation = Vacation.find(params[:id])
    if request.xhr?
      render 'show', :layout => false
      return
    end
  end

  # GET /vacations/new
  # GET /vacations/new.json
  def new
    @vacation = Vacation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @vacation }
    end
  end

  # GET /vacations/1/edit
  def edit
    @vacation = Vacation.find(params[:id])
  end

  # POST /vacations
  # POST /vacations.json
  def create
    @gotodate = params[:vacation][:starts_at].to_time.to_i * 1000
    set_tz_offset(:vacation)
    @user = User.find(params[:user_id])
    @vacation = @user.vacations.build(params[:vacation])


    respond_to do |format|
      if @vacation.save
        format.js { render 'update_listing', :layout => false }
      else
        format.js { render :partial => 'shared/error', :locals => {:target => @vacation} }
      end
    end
  end

  # PUT /vacations/1
  # PUT /vacations/1.json
  def update
    @vacation = Vacation.find(params[:id])

    respond_to do |format|
      if @vacation.update_attributes(params[:vacation])
        format.html { redirect_to @vacation, :notice => 'Vacation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @vacation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vacations/1
  # DELETE /vacations/1.json
  def destroy
    @user = User.find(params[:user_id])
    vacation = Vacation.find(params[:id])
    @gotodate = vacation.starts_at.to_time.to_i * 1000
    vacation.destroy
    respond_to do |format|
      format.html do
        redirect_to :back
      end
      format.js { render 'update_listing', :layout => false }
    end
  end

  def refresh_listing
    @user = User.find(params[:user_id])
    render 'update_listing', :layout => false
  end  
end
