require_relative '../active_record/sql_object'
require_relative './book'

class Author < SQLObject
  self.finalize!
  has_many "books"
end
