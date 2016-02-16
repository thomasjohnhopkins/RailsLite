require_relative '../models/book.rb'

class BooksController < ControllerBase
  def new
    @book = Book.new
    render "new"
  end

  def create
    @book = Book.new(params["book"])
    @book.set({session_token: SecureRandom.urlsafe_base64})
    if @book.save
      flash["flash now"] = "#{@book.title} has been added to your book list!"
      session[:session_token] = @book.session_token
      redirect_to("/books")
    else
      flash.now["flash now"] = "Error!"
      render "new"
    end
  end

  def index
    @books = Books.all
    render "index"
  end
end
