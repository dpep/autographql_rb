AutoGraphQL
======
![Gem](https://img.shields.io/gem/dt/autographql?style=plastic)
[![codecov](https://codecov.io/gh/dpep/rb_autographql/branch/main/graph/badge.svg)](https://codecov.io/gh/dpep/rb_autographql)

Automagically generate GraphQL types and queries for Active Record models

####  Usage
```ruby
require 'autographql'


class User < ActiveRecord::Base
  # register this model with AutoGraphQL
  graphql
end

# or only show specific fields
class User < ActiveRecord::Base
  graphql fields: [ :name, :pic ]
end

# or via
AutoGraphQL.register User

# generate query schema
class Schema < GraphQL::Schema
  query AutoGraphQL::QueryType
end

puts GraphQL::Schema::Printer.print_schema(Schema)
```
####  Full Example
```ruby
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

puts 'Daniel' == Schema.execute(query).values.first['person']['name']
```


----
## Installation

```ruby
# Gemfile
gem "autographql"
```

or

```
gem install autographql
```


##  Thanks To
Daniel O'Brien: https://github.com/dobs/autographql

Andy Kriger: https://github.com/rmosolgo/graphql-ruby/issues/945
