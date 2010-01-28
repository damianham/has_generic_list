require File.dirname(__FILE__) + '/abstract_unit'

class GenericListItemTest < ActiveSupport::TestCase

  test "to_s is the same as item_value" do
    item = GenericListItem.new(
      :klazz => books(:acme), :item_type => 'Tools', :item_value => 'Hammer'
    )
    assert_equal 'Hammer', item.to_s
  end
end
