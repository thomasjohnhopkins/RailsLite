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

<!-- ## Getting Started

Instructions to come -->

## Technologies
* Ruby
* Rack
* ERB
* SQLite3
* Dynamic Archive (Custom ORM)
