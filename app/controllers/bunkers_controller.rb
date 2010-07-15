class BunkersController < ApplicationController
  # GET /bunkers
  # GET /bunkers.xml
  def index
    @bunkers = Bunker.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bunkers }
    end
  end

  # GET /bunkers/1
  # GET /bunkers/1.xml
  def show
    @bunker = Bunker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bunker }
    end
  end

  # GET /bunkers/new
  # GET /bunkers/new.xml
  def new
    @bunker = Bunker.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bunker }
    end
  end

  # GET /bunkers/1/edit
  def edit
    @bunker = Bunker.find(params[:id])
  end

  # POST /bunkers
  # POST /bunkers.xml
  def create
    @bunker = Bunker.new(params[:bunker])

    respond_to do |format|
      if @bunker.save
        flash[:notice] = 'Bunker was successfully created.'
        format.html { redirect_to(@bunker) }
        format.xml  { render :xml => @bunker, :status => :created, :location => @bunker }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bunker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bunkers/1
  # PUT /bunkers/1.xml
  def update
    @bunker = Bunker.find(params[:id])

    respond_to do |format|
      if @bunker.update_attributes(params[:bunker])
        flash[:notice] = 'Bunker was successfully updated.'
        format.html { redirect_to(@bunker) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bunker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bunkers/1
  # DELETE /bunkers/1.xml
  def destroy
    @bunker = Bunker.find(params[:id])
    @bunker.destroy

    respond_to do |format|
      format.html { redirect_to(bunkers_url) }
      format.xml  { head :ok }
    end
  end
  def explosives_load
    @bunkers = Bunker.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bunkers }
    end
  end
end
