# has_generic_list

 is a plugin to store lists of data associated with a model without having to create lots of tables, 
one for each type of data.

If you find this plugin useful, please consider a donation to show your support!

  http://www.paypal.com/cgi-bin/webscr?cmd=_send-money
  
  Email address: damianham@gmail.com

You can also consider hiring me to develop your web application, please drop me a line to discuss your project.

## Installation

>  	ruby script/plugin install git://github.com/damianham/has_generic_list.git

or

>	gem 'has_generic_list', :git => 'git://github.com/damianham/has_generic_list.git'
  
### Prepare database

Generate and apply the migration:

>  	ruby script/generate has_generic_list_migration
>  	rake db:migrate

### Basic usage

Let's suppose you have a Company model and you want to store lists of data associated
with each Company e.g

- countries of operation
- languages spoken
- product names...... etc. etc.  you get the idea

i.e lists of any kind of data.  You could also serialize an object and store that as the list item value as long as
the serialized data length is less than the item_value column length in the generic_list_items table.  If you want to store
larger data then change the item_value column to a text column.

The first step is to add _has_generic_list_ to the Company class:

  	class Company < ActiveRecord::Base
    	  # the type names MUST be singular, if typename == typename.pluralize then an exception is raised
    	  has_generic_list :types => [:country,:language,:office,:person] # as many types as you need
  	end
  
We can now use the pluralized methods generated by _has_generic_list_ for each data type which work like regular array attribute accessors.


>  	c = Company.find(:first)
>
>  	c.countries # []
>  	c.countries = ["UK", "US","CA"]
>
>  	c.languages # []
>  	c.languages = ["English", "French","Spanish"]
>
>  	c.countries # ["UK", "US","CA"]
>  	c.languages # ["English", "French","Spanish"]
  
To display the value as a String use to_s, i.e. 

> 	c.languages[0].to_s # "English"

You can get all elements of the list as a comma separated String with to_s on the list itself, i.e

>	c.languages.to_s # "English, French, Spanish"

You can also add or remove elements of data.

>  	c.languages.add("German", "Dutch")
>  	c.languages.remove("French")
  
You can do the normal array traversal on the list but you have to use the add/remove methods to modify the list.

### Finding objects by the generic list data

To retrieve objects that have a particular list entry use <datatype>_find_with_list, i.e

>  	companies = Company.languages_find_with_item('Spanish')

which is just a convenience method for

>  	Company.find_with_generic_list_item(:language,'Spanish')  # note the singular type name

and to just get the object identifiers use

>  	company_ids = Company.languages_find_ids_with_item('Spanish')

which returns an array of ids
 
### Other

Problems, comments, and suggestions all welcome damianham@gmail.com
