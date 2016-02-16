require_relative '../models/author.rb'

require 'securerandom'

class SessionsController < ControllerBase
  def new
    return redirect_to "/books" if current_user
    @author = Author.new
    render "new"
  end

  def create
    return redirect_to "/books" if current_user
    @author = Author.where(params["author"]).first
    if @author
      flash["flash now"] = "Welcome #{@author.name}! Check below for an explanation."
      @author.set({session_token: SecureRandom.urlsafe_base64})
      @author.save
      session[:session_token] = @author.session_token
      redirect_to("/books")
    else
      flash.now["flash now"] = "Account could not be found."
      render "new"
    end
  end

  def destroy
    current_user.set({session_token: SecureRandom.urlsafe_base64})
    current_user.save
    current_user = nil
    session["session_token"] = nil
    redirect_to("/books")
  end
end
