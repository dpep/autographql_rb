require 'active_record'

require_relative 'db'


# set up database schema
ActiveRecord::Schema.define do
  create_table :people do |t|
    t.string :name
  end

  create_table :pets do |t|
    t.string :name
    t.integer :person_id
  end
end


# define models
class Person < ActiveRecord::Base
  has_many :pets
  graphql
end

class Pet < ActiveRecord::Base
  belongs_to :person
end


# AutoGraphQL.register Person
AutoGraphQL.register Pet
