require_relative 'db'


# set up database schema
ActiveRecord::Schema.define do
  create_table :people do |t|
    t.string :name
    t.json :data
    t.decimal :age
    t.integer :location_id
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
    t.integer :location_id
  end
end


# define models
class Person < ActiveRecord::Base
  has_many :pets
  belongs_to :location

  def awesomeness
    100
  end

  def friends
    self.class.where.not(id: id)
  end

  graphql methods: {
    awesomeness: Integer,
    friends: [ Person ],
  }
end

class Pet < ActiveRecord::Base
  belongs_to :person
  belongs_to :location
end

class Location < ActiveRecord::Base
  belongs_to :location
end


# AutoGraphQL.register Person
AutoGraphQL.register Pet
AutoGraphQL.register Location
