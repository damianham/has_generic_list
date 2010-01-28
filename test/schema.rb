ActiveRecord::Schema.define :version => 0 do

  create_table :generic_list_items, :force => true do |t|

    t.column :klazz_type, :string  # the model name
    t.column :klazz_id, :integer   # the id of the model instance

    t.column :item_type, :string   # the list data type
    t.column :item_value, :string  # the data value

    t.timestamps
  end
  
  create_table :books, :force => true do |t|
    t.column :name, :string
    t.timestamps
  end
  
  create_table :chapters, :force => true do |t|
    t.column :name, :string
    t.column :book_id, :integer
    t.timestamps
  end
end
