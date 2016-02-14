require_relative '../active_record/sql_object.rb'
require_relative 'book'

class User < SQLObject
  self.finalize!
  has_many "books"
end
