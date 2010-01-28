require File.dirname(__FILE__) + '/abstract_unit'

class GenericDataListTest < ActiveSupport::TestCase

  def test_from_single_name
    assert_equal "Wigwam", GenericDataList.new(books(:acme),'product',"Wigwam")[0].to_s
  end
  
  def test_from_blank
    assert_equal [], GenericDataList.new(books(:acme),'product',nil)
    assert_equal [], GenericDataList.new(books(:acme),'product',"")
  end

  def test_from_single_quoted_value
    assert_equal 'Wigwam, Acme', GenericDataList.new(books(:acme),'product',['Wigwam, Acme'])[0].to_s
  end

  def test_new_accepts_array
    orig = ["Wigwam", "Acme"]
    values = GenericDataList.new(books(:acme),'product',orig)
    assert_equal orig, [values[0].to_s, values[1].to_s]
  end

  def test_add
    values = GenericDataList.new(books(:acme),'product',"Wigwam")
    assert_equal "Wigwam", values[0].to_s

    assert_equal 2, values.add("Acme").size
    assert_equal 3, values.add(["Bolts"]).size
    assert_equal ["Wigwam", "Acme", "Bolts"], [values[0].to_s, values[1].to_s, values[2].to_s]
  end

  def test_remove
    values = GenericDataList.new(books(:acme),'product',["Wigwam", "Acme"])
    assert_equal "Acme", values.remove("Wigwam")[0].to_s
    assert_equal [], values.remove("Acme")
  end


  def test_new_removes_white_space
    values = GenericDataList.new(books(:acme),'product',["   Wigwam  ", "Acme  "])
    assert_equal ["Wigwam", "Acme"], [values[0].to_s, values[1].to_s]
    values = GenericDataList.new(books(:wigwam),'product',["   Wigwam  ", "Acme Bolts"])
    assert_equal ["Wigwam", "Acme Bolts"], [values[0].to_s, values[1].to_s]
  end
 
  def test_duplicate_values_removed
    assert_equal 1, GenericDataList.new(books(:acme),'product',["Wigwam", "Wigwam"]).size
  end

=begin
  def test_alternative_delimiter
    GenericDataList.delimiter = " "
    
    assert_equal ['One Two'], GenericDataList.new(books(:acme),'product',"One Two")
    assert_equal ['One two', 'three', 'four'], GenericDataList.new(books(:acme),'product','"One two" three four')
  ensure
    GenericDataList.delimiter = ","
  end
  


  def test_to_s_with_commas
    assert_equal "Question, Crazy Animal", GenericDataList.new(books(:acme),'product',"Question", "Crazy Animal").to_s
  end
  
  def test_to_s_with_alternative_delimiter
    GenericDataList.delimiter = " "
    
    assert_equal '"Crazy Animal" Question', GenericDataList.new(books(:acme),'product',"Crazy Animal", "Question").to_s
  ensure
    GenericDataList.delimiter = ","
  end

  
  def test_toggle
    values = GenericDataList.new(books(:acme),'product',"One", "Two")
    assert_equal %w(One Three), values.toggle("Two", "Three")
    assert_equal %w(), values.toggle("One", "Three")
    assert_equal %w(Four), values.toggle("Four")
  end

=end
end
