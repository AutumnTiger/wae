class Quotation < ApplicationRecord
  attr_accessor :new_category


  validates_presence_of :author_name

  #validates_presence_of :category


  validates_presence_of :quote

end
