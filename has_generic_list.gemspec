Gem::Specification.new do |s|
  s.name     = "has_generic_list"
  s.version  = "1.2"
  s.date     = "2012-06-04"
  s.summary  = "Rails plugin to store lists of generic data."
  s.email    = "damianham@gmail.com"
  s.homepage = "http://github.com/damianham/has_generic_list"
  s.description = "Rails plugin to store lists of generic data."
  s.has_rdoc = true
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.rubyforge_project = "has_generic_list"
  s.authors  = "Damian Hamill"
  s.files    = [
    "has_generic_list.gemspec",
    "CHANGELOG",
    "generators/has_generic_list_migration",
    "generators/has_generic_list_migration/has_generic_list_migration_generator.rb",
    "generators/has_generic_list_migration/templates",
    "generators/has_generic_list_migration/templates/migration.rb",
    "init.rb",
    "lib/has_generic_list.rb",
    "lib/generic_list_item.rb",
    "lib/generic_data_list.rb",
    "MIT-LICENSE",
    "Rakefile",
    "README",
    ]
  s.test_files = [
    "test/fixtures",
    "test/fixtures/book.rb",
    "test/fixtures/books.yml",
    "test/fixtures/chapter.rb",
    "test/fixtures/chapters.yml",
    "test/fixtures/generic_list_items.yml",
    "test/abstract_unit.rb",
    "test/has_generic_list_test.rb",
    "test/database.yml",
    "test/schema.rb",
    "test/generic_data_list_test.rb",
    "test/generic_list_item_test.rb"
    ]
end
