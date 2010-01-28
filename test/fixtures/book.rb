class Book < ActiveRecord::Base

  has_generic_list :types => [:country,:language]

  has_many :chapters
  
end
