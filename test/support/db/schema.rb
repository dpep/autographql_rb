require 'sqlite3'
require 'active_record'


# create in-memory database and connect
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)


# set up database schema
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :owners do |t|
    t.string :name
  end

  create_table :pets do |t|
    t.string :name
    t.integer :owner_id
  end
end


# define models
class ::Owner < ActiveRecord::Base
  has_many :pets
end

class ::Pet < ActiveRecord::Base
  belongs_to :owner
end


Owner.send :graphql_type, name: 'DaOwner'
Pet.send :graphql_type, name: 'Pet'
