class HasGenericListMigration < ActiveRecord::Migration
  def self.up
    create_table :generic_list_items do |t|

      t.column :klazz_type, :string  # the model name
      t.column :klazz_id, :integer   # the id of the model instance

      t.column :item_type, :string   # the list data type
      t.column :item_value, :string  # the data value

      t.timestamps
    end

    add_index :generic_list_items, [:klazz_type, :klazz_id, :item_type, :item_value], :unique => true, :name => 'generic_list_items'

  end
  
  def self.down
    drop_table :generic_list_items

  end
end
