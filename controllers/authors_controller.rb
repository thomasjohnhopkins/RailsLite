require_relative '../models/author.rb'

class AuthorsController < ControllerBase
  def new
    return redirect_to "/" if current_user
    @author = Author.new
    render "new"
  end

  def create
    return redirect_to "/" if current_user
    @author = Author.new(params["author"])
    @author.set({session_token: SecureRandom.urlsafe_base64})
    if @author.save
      flash["flash now"] = "Welcome #{@author.name}!"
      session[:session_token] = @author.session_token
      redirect_to("/books")
    else
      flash.now["flash now"] = "Error!"
      render "new"
    end
  end
end
