# Rails Lite

In an attempt to better understand the magic of the Rails platform,
I decided to recreate the basic functionality that it provides.

## Features
- Uses Rack middleware to connect web server to the MVC framework.
- Built architectural pattern to organize the database.  
- Includes a custom ControllerBase class to provide controller inheritance.
- Implements custom Route and Router classes to pass HTTP requests to the controllers and responses to the views.
- Stores data in cookies to keep information on current user.
- Capable of rendering HTML/ERB templates.
- Use CSRF to evaluate whether a form is valid.

## Technologies
* Ruby
* Rack
* ERB
* SQLite3
* Agile Record (Custom ORM)

##Getting Started
* Clone the repo
* run `bundle install`
* Put sql files in db/migrations/ numbered in the order you want them to be executed.  There is a example sql file that will be ignored, but feel free to take a look.
* Create the appropriate models for your tables in the app/models/ directory

```
# app/models/user.rb

require_relative '../agile_record/sql_object.rb'
require_relative './book.rb'

class User < SQLObject

  self.finalize!
  has_many "books"

end
```

* Construct routes. This can be accomplished using a regex and giving a controller and method name.  Please see the example below for sample routes concerning users and sessions.

```
# config/routes.rb

ROUTER.draw do
  get Regexp.new("^/users$"), UsersController, :index
  get Regexp.new("^/users/new$"), UsersController, :new
  post Regexp.new("^/users$"), UsersController, :create
  get Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :show
  get Regexp.new("^/session/new/?$"), SessionsController, :new
  post Regexp.new("^/sessions"), SessionsController, :create
  post Regexp.new("^/session"), SessionsController, :destroy
  delete Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :destroy
end
```
* Add corresponding controllers in app/controllers/ directory

```
# app/controllers/users_controller.rb

require_relative '../models/user.rb'

class UsersController < ControllerBase
  def index
    @users = User.all

    render :index
  end
end
```

* Create corresponding erb views in app/views/<controller> directory

```
# app/views/users/index.html.erb

<ul>
  <% @users.each do |user| %>
    <li><%= user.name %></li>
  <% end %>
</ul>
```
