require_relative '../active_record/sql_object'
require_relative './author'

class Book < SQLObject
  self.finalize!
  belongs_to "author"
end
