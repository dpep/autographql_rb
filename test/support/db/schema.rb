require 'active_record'

require_relative 'db'


# set up database schema
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


Owner.send :graphql
Pet.send :graphql
