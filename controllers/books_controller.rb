require_relative '../models/book.rb'

class BooksController < ControllerBase
  def new
    @book = Book.new
    render "new"
  end

  def create
    @book = Book.new(params["book"])
    @book.set(author_id: current_user.id)
    if @book.save
      flash["flash now"] = "#{@book.title} has been added to your book list!"
      redirect_to("/books")
    else
      flash.now["flash now"] = "Error!"
      render "new"
    end
  end

  def index
    @books = Book.all
    render "index"
  end

  def edit
    @book = Book.find(params["id"])
    return redirect_to "/books" unless current_user && current_user.id == @book.author_id
    render "edit"
  end

  def update
    @book = Book.find(params[:id])
    return redirect_to "/books" unless current_user && current_user.id == @book.author_id
    @book.set(title: params["book"]["title"])
    if @book.save
      flash["flash now"] = "#{@book.title} updated!"
      redirect_to("/books/#{@book.id}")
    else
      render "error"
    end
  end
end
