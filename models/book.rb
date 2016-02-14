require_relative '../active_record/sql_object.rb'
require_relative 'author'

class Book < SQLObject
  self.finalize!
  belongs_to "author"
end
