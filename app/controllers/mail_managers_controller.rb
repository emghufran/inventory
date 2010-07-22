class MailManagersController < ApplicationController
  # GET /mail_managers
  # GET /mail_managers.xml
  def index
    @mail_managers = MailManager.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mail_managers }
    end
  end

  # GET /mail_managers/1
  # GET /mail_managers/1.xml
  def show
    @mail_manager = MailManager.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mail_manager }
    end
  end

  # GET /mail_managers/new
  # GET /mail_managers/new.xml
  def new
    @mail_manager = MailManager.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mail_manager }
    end
  end

  # GET /mail_managers/1/edit
  def edit
    @mail_manager = MailManager.find(params[:id])
  end

  # POST /mail_managers
  # POST /mail_managers.xml
  def create
    @mail_manager = MailManager.new(params[:mail_manager])

    respond_to do |format|
      if @mail_manager.save
        flash[:notice] = 'MailManager was successfully created.'
        format.html { redirect_to(@mail_manager) }
        format.xml  { render :xml => @mail_manager, :status => :created, :location => @mail_manager }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mail_manager.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mail_managers/1
  # PUT /mail_managers/1.xml
  def update
    @mail_manager = MailManager.find(params[:id])

    respond_to do |format|
      if @mail_manager.update_attributes(params[:mail_manager])
        flash[:notice] = 'MailManager was successfully updated.'
        format.html { redirect_to(@mail_manager) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mail_manager.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mail_managers/1
  # DELETE /mail_managers/1.xml
  def destroy
    @mail_manager = MailManager.find(params[:id])
    @mail_manager.destroy

    respond_to do |format|
      format.html { redirect_to(mail_managers_url) }
      format.xml  { head :ok }
    end
  end
end
