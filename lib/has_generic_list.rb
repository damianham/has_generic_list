module ActiveRecord #:nodoc:
  module Has #:nodoc:
    module GenericList #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods

        #
        # Options:
        # *  <tt>:types</tt> - Specifies a set of list types
        # Examples:
        #    has_generic_list :types => [:language,:service,:product,:trading_area]
        #  the type names MUST be singular, if any typename == typename.pluralize then an exception is raised

        def has_generic_list(options = {})
          
          has_many :generic_list_items, :as => :klazz ,  :dependent => :destroy
          
          #alias_method_chain :reload, :reload_generic_data_lists

          # create the class methods
          options[:types].each do |typename|
            symbol_name = typename.to_s.pluralize

            if symbol_name.to_s == typename.to_s
              raise ArgumentError, "type names for generic list items must be singular"
            end

            self.class_eval %{
                def #{self.name}.#{symbol_name}_find_with_item(item_values, *args)
                  find_with_generic_list_item('#{typename}',item_values,*args)
                end
            }, __FILE__, __LINE__

            self.class_eval %{
                def #{self.name}.#{symbol_name}_find_ids_with_item(item_values, *args)
                  find_ids_with_generic_list_item('#{typename}',item_values,*args)
                end
            }, __FILE__, __LINE__

            class_eval %{
                def #{symbol_name}
                  return @__#{typename} if @__#{typename}

                  @__#{typename} = GenericDataList.new(self, '#{typename}')
                end

               
            }, __FILE__, __LINE__

            class_eval %{
                def #{symbol_name}=(*args)
                  list = #{symbol_name}
                  list.each do |item|
                    item.destroy
                  end
                  save
                  @__#{typename} = GenericDataList.new(self,'#{typename}',*args)
                end
            }, __FILE__, __LINE__

          end
        end

        # find objects of the sending class that have one of the given values
        #
        # Parameters:
        #   :typename -  the item_type
        #   :item_values - a set of item values - find objects with any of the values
        #   :options
        #
        # Options:
        #   :conditions - A piece of SQL conditions to add to the query
        def find_with_generic_list_item(typename,item_values,*args)
          return [] if item_values.is_a?(Array) && item_values.empty?
          return [] if item_values.is_a?(String) && item_values.blank?

          options = find_options_for_find_with_generic_list_item(typename,item_values,*args)
          options.blank? ? [] : find(:all, options)
        end


        # find objects IDs of the sending class that have one of the given values
        #
        # Parameters:
        #   :typename -  the item_type
        #   :item_values - a set of item values - find objects with any of the values
        #   :options
        #
        # Options:
        #   :conditions - A piece of SQL conditions to add to the query
        def find_ids_with_generic_list_item(typename,item_values,*args)
          return [] if item_values.is_a?(Array) && item_values.empty?
          return [] if item_values.is_a?(String) && item_values.blank?
          
          dbase = Class.new(Tableless) do
            self.column :id, :integer
          end

          options = find_options_for_find_with_generic_list_item(typename,item_values,*args)

          query = "SELECT DISTINCT #{table_name}.id FROM #{table_name} " + options[:joins] + ' WHERE ' + options[:conditions]
          ids = []
          items = dbase.find_by_sql(query)
          items.each {|item|
            ids << item.id
          }
          ids
        end

        def find_options_for_find_with_generic_list_item(typename, item_values,options = {})
          item_values = item_values.is_a?(Array) ? item_values : [item_values.to_s]
          options = options.dup

          return {} if typename.to_s.blank?

          conditions = []
          conditions << sanitize_sql(options.delete(:conditions)) if options[:conditions]

          joins = [
            "INNER JOIN #{GenericListItem.table_name} ON #{GenericListItem.table_name}.klazz_id = #{table_name}.#{primary_key} AND #{GenericListItem.table_name}.klazz_type = #{quote_value(base_class.name)}"
          ]

          conditions << sanitize_sql(["#{GenericListItem.table_name}.item_type = ?", typename])
          conditions << values_condition(item_values)

          { :select => "DISTINCT #{table_name}.*",
            :joins => joins.join(" "),
            :conditions => conditions.join(" AND ")
          }.reverse_merge!(options)
        end

        private
        def values_condition(item_values)
          condition = item_values.map { |t| sanitize_sql(["#{GenericListItem.table_name}.item_value = ?", t]) }.join(" OR ")
          "(" + condition + ")" unless condition.blank?
        end

        # used by find_ids....
        class Tableless < ActiveRecord::Base
          def self.columns
            @columns ||= [];
          end

          def self.column(name, sql_type = nil, default = nil, null = true)
            columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,
              sql_type.to_s, null)
          end

          # Override the save method to prevent exceptions.
          def save(validate = true)
            validate ? valid? : true
          end
        end
        
      end
      

    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Has::GenericList)
