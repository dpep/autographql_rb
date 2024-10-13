# create in-memory database and connect
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

# silence table creation logging
ActiveRecord::Migration.verbose = false
