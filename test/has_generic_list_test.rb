require File.dirname(__FILE__) + '/abstract_unit'

class HasGenericListTest < ActiveSupport::TestCase

  def test_find_with_item
    assert_equivalent [books(:acme),books(:wigwam)], Book.languages_find_with_item('English')
    assert_equal books(:acme), Book.languages_find_with_item('French')[0]
    assert_equal books(:wigwam), Book.languages_find_with_item('Spanish')[0]
  end


  def test_find_ids_with_item
    assert_equivalent [books(:acme).id,books(:wigwam).id], Book.languages_find_ids_with_item('English')
    assert_equal [books(:acme).id], Book.languages_find_ids_with_item('French')
    assert_equal [books(:wigwam).id], Book.languages_find_ids_with_item('Spanish')
  end

  def test_find_with_nothing
    assert_equal [], Book.languages_find_with_item('')
    assert_equal [], Book.languages_find_with_item([])
  end

  def test_find_ids_with_nothing
    assert_equal [], Book.languages_find_ids_with_item('')
    assert_equal [], Book.languages_find_ids_with_item([])
  end

  def test_find_with_include_and_order
    assert_equivalent [books(:acme),books(:wigwam)], Book.languages_find_with_item('English', :order =>
        "generic_list_items.item_value DESC", :include => :chapters)
  end
  
  def test_find_with_nonexistant_data
    assert_equal [], Book.languages_find_with_item('fgsdfgsdfg')
    assert_equal [], Book.languages_find_with_item(['sdfgsdfg'])
  end
   
  def test_find_with_conditions
    assert_equal [], Book.languages_find_with_item('French', :conditions => '1=0')
  end
  
  def test_find_with_duplicates_options_hash
    options = { :conditions => '1=1' }.freeze
    assert_nothing_raised { Book.languages_find_with_item("Spanish", options) }
  end

  def test_find_options_for_find_with_no_values_returns_empty_hash
    assert_equal Hash.new, Book.find_options_for_find_with_generic_list_item("","")
    assert_equal Hash.new, Book.find_options_for_find_with_generic_list_item("",[nil])
  end
 
  def test_reassign_list
    assert_equivalent ["English", "French"], [books(:acme).languages[0].to_s,books(:acme).languages[1].to_s]
    
    books(:acme).languages = ["German","Spanish"]
    
    assert_equivalent ["German","Spanish"], [books(:acme).languages[0].to_s,books(:acme).languages[1].to_s]
  end

  def test_add_item
    assert_equivalent ["English", "French"], [books(:acme).languages[0].to_s,books(:acme).languages[1].to_s]
    books(:acme).languages.add("Spanish")
    assert_equivalent ["English", "French","Spanish"], [books(:acme).languages[0].to_s,books(:acme).languages[1].to_s,books(:acme).languages[2].to_s]
  end
  
  def test_remove_item
    assert_equivalent ["English", "French"], [books(:acme).languages[0].to_s,books(:acme).languages[1].to_s]
    books(:acme).languages.remove("French")
    assert_equivalent ["English"], [books(:acme).languages[0].to_s]
  end

end
