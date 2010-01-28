class GenericListItem < ActiveRecord::Base #:nodoc:

  belongs_to :klazz, :polymorphic => true

  def to_s
    item_value
  end

end
