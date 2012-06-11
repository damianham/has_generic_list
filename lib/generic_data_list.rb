class GenericDataList < Array
  cattr_accessor :delimiter
  self.delimiter = ','
  
  def initialize(record,typename,values = nil)
    @__record = record
    @__internal_typename = typename

    if values
      self.add(values)
    else
      @__record.generic_list_items.each do |item|
        self << item if item.item_type == @__internal_typename
      end
    end
  end

  # Add items to the list. Duplicate or blank items will be ignored.
  #
  #   <typename>.add("Fun", "Happy")
  # 
  def add(*values)
    fixup_values! values

    if values.is_a?(Array) && values.each do |name|
 #       puts 'adding ' + name

        if ! name.blank? && ! include?(name)
          item = GenericListItem.new(
            :klazz => @__record, :item_type => @__internal_typename, :item_value => name
          )
          @__record.generic_list_items.push(item)
          push(item)
        end
      end
    else
      if ! values.blank? && ! include?(values)
          item = GenericListItem.new(
            :klazz => @__record, :item_type => @__internal_typename, :item_value => values
          )
          @__record.generic_list_items.push(item)
          push(item)
        end
    end

    self
  end

  def include?(value)
    self.each do |item|
 #     puts 'compare ' + item.to_s + ' class == ' + item.class.name
      return true if item.item_value == value
    end
    false
  end

  # Remove specific items from the list.
  # 
  #   <typename>.remove("Sad", "Lonely")
  #
  # Like #add, the <tt>:parse</tt> option can be used to remove multiple items in a string.
  # 
  #   <typename>.remove("Sad, Lonely", :parse => true)
  def remove(*values)

    if ! values.is_a?(Array)
      values = fixup_values!(values)
    end

    values.each do |name|
      self.each do |item|
        if item.item_value == name
          item.destroy
          delete item
        end
        
      end
    end
    self
  end
  
  # Toggle the presence of the given items.
  # If an item is already in the list it is removed, otherwise it is added.
  def toggle(*values)
    if ! values.is_a?(Array)
      values = fixup_values!(values)
    end
    
    values.each do |name|
      include?(name) ? remove(name) : add(name)
    end
    
    self
  end

  def inspect
    to_s
  end

  # Transform the <typename> list into an item string.
  # The items are joined with <tt>GenericDataList.delimiter</tt> and quoted if necessary.
  #
  #   <typename> = GenericDataList.new(self,'shape',["Round", "Square,Cube"])
  #   <typename>.to_s # 'Round, "Square,Cube"'
  def to_s
    
    map do |item|
      if item.respond_to?('item_value')
        item.item_value.include?(delimiter) ? "\"#{item.item_value}\"" : item.item_value
      end
    end.join(delimiter.ends_with?(" ") ? delimiter : "#{delimiter} ")
  end
  
  private
  # Remove whitespace, duplicates, and blanks.
  
  def fixup_values!(args)
    if args.is_a?(Array)  
      args.flatten!
      args.reject!(&:blank?)
      args.map!(&:strip)
      args.uniq!
    end
  end
 
end
