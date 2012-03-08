class OncallTimesController < ApplicationController
  # GET /oncall_times
  # GET /oncall_times.json
  def index
    @oncall_times = OncallTime.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @oncall_times }
    end
  end

  # GET /oncall_times/1
  # GET /oncall_times/1.json
  def show
    @oncall_time = OncallTime.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @oncall_time }
    end
  end

  # GET /oncall_times/new
  # GET /oncall_times/new.json
  def new
    @oncall_time = OncallTime.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @oncall_time }
    end
  end

  # GET /oncall_times/1/edit
  def edit
    @oncall_time = OncallTime.find(params[:id])
  end

  # POST /oncall_times
  # POST /oncall_times.json
  def create
    @oncall_time = OncallTime.new(params[:oncall_time])

    respond_to do |format|
      if @oncall_time.save
        format.html { redirect_to @oncall_time, :notice => 'Oncall time was successfully created.' }
        format.json { render :json => @oncall_time, :status => :created, :location => @oncall_time }
      else
        format.html { render :action => "new" }
        format.json { render :json => @oncall_time.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /oncall_times/1
  # PUT /oncall_times/1.json
  def update
    @oncall_time = OncallTime.find(params[:id])

    respond_to do |format|
      if @oncall_time.update_attributes(params[:oncall_time])
        format.html { redirect_to @oncall_time, :notice => 'Oncall time was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @oncall_time.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /oncall_times/1
  # DELETE /oncall_times/1.json
  def destroy
    @oncall_time = OncallTime.find(params[:id])
    @oncall_time.destroy

    respond_to do |format|
      format.html { redirect_to oncall_times_url }
      format.json { head :no_content }
    end
  end
end
