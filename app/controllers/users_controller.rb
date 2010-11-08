class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  before_filter :validate_admin_authentication, :only => [:index,:update, :show, :edit, :activate, :destroy]
  
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      Emailer.deliver_send_activation_request(@user)
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  Administrator will activate your account and you will receive an email notification when your account is approved."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def activate
  	 user_id = params[:id]
  	 @user = User.find(user_id.to_i)
  	 if !@user #didnt find user.
  	 	flash[:error]  = "We couldn't find the requested user."
  	 	redirect_to :controller => 'main', :action => 'index'
  	 elsif @user.is_approved == 1
  	 	flash[:error]  = "User has already been Approved"
  	 	redirect_to :controller => 'main', :action => 'index'
  	 end
  	 
  	 approval = params[:approval]
  	 role = params["role"]
	 if approval.to_i == 1
	 	@user.is_approved = 1
	 	@user.role = (role == "Manager" ? role : "Engineer")
	 	@user.save
	 	Emailer.deliver_account_activation_confirmation(@user)
	 	flash[:notice] = "User has been approved and will now be able to use the site!"
	 	redirect_to :controller => 'main', :action => 'index'
	 elsif approval && approval.to_i == 0
	 	@user.is_approved = 0
	 	@user.role = (role == "Manager" ? role : "Engineer")
	 	@user.save
	 	#Emailer.deliver_account_activation_confirmation(@user)
	 	flash[:notice] = "User has been restricted and will not be able to use the site!"
	 	redirect_to :controller => 'main', :action => 'index'
	 end
  end
  def index
    @users = User.find(:all)
    respond_to do |format|
      format.html  #index.html.erb
      format.xml  { render :xml => @bunkers }
    end
  end
  def show
    @user = User.find(params[:id])
    if @user[:role]=="Manager"
      @user[:role]="Administrator"
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  def edit
    @user = User.find(params[:id])
    if(@user[:role]=="Manager")
      @user[:role]="Administrator"
    end
  end
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        session[:location]=@user.location
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bunker.errors, :status => :unprocessable_entity }
      end
    end
  end

end
