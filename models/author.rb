require_relative '../agile_record/sql_object.rb'
require_relative './book.rb'

class Author < SQLObject
  self.finalize!
  has_many "books"
end
