AutoGraphQL
======

Automagically generate GraphQL types and queries

#### Install
```gem install autographql```


#### Usage
```
require 'active_record'
require 'autographql'


# create in-memory database and connect
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

# set up database schema
ActiveRecord::Schema.define do
  create_table :people do |t|
    t.string :name
  end
end

class Person < ActiveRecord::Base
  attr_accessor :name
  
  # register this model with AutoGraphQL
  graphql
end

# create a person
Person.create(name: 'Daniel')


# use automatically generated query to create a GraphQL schema
class Schema < GraphQL::Schema
  query AutoGraphQL::QueryType
end

# double check your schema
puts GraphQL::Schema::Printer.print_schema(Schema)

# perform a query
query = "
{
  person(id: 1) {
    name
  }
}"

'Daniel' == Schema.execute(query).values.first['person']['name']
