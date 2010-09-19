class AdminController < ApplicationController
    layout 'application'
	#before_filter :validate_authentication
	before_filter :validate_admin_authentication
    def pending_users
        @pending_users = User.find(:all, :conditions => "is_approved = 0", :order => 'id DESC') 
    end
   
    def activate_user
        #redirect_to :controller => 'main', :action => 'index' if session[:role_id] != 3
        user = User.find_by_id(params[:id])
        if !user or user.blank?
            redirect_to :controller => 'main', :action => 'index' 
            return
        end
        user.is_approved = 1
        user.save
        redirect_to :action => "pending_users", :controller => 'admin'
        return
    end 
    
end
