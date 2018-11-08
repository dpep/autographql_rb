require 'active_record'

require_relative 'db'


# set up database schema
ActiveRecord::Schema.define do
  create_table :people do |t|
    t.string :name
    t.json :data
    t.decimal :age
    t.datetime :created_at, default: -> { 'CURRENT_TIMESTAMP' }
  end

  create_table :pets do |t|
    t.string :name

    t.integer :person_id
    t.integer :location_id
  end

  create_table :locations do |t|
    t.string :name
    t.date :founded

    t.integer :object_id
    t.string :object_type
  end
end


# define models
class Person < ActiveRecord::Base
  has_many :pets
  has_one :location, :as => :object

  graphql methods: [ :happy ]

  def happy
    true
  end
end

class Pet < ActiveRecord::Base
  belongs_to :person
  has_one :location, :as => :object
end

class Location < ActiveRecord::Base
end


# AutoGraphQL.register Person
AutoGraphQL.register Pet
AutoGraphQL.register Location
