class MainController < ApplicationController
  def index
    if(!session[:user_id] || session[:user_id] <= 0)
      redirect_to :controller => 'sessions', :action => 'new'
    end
  end
end
