require 'minitest/autorun'
require 'graphql'

require_relative '../lib/autographql'
require_relative 'support/db/seed'


###   Setup   ###

# PetType not defined yet, so must use .define style
OwnerType = GraphQL::ObjectType.define do
  name 'Owner'

  field :id, types.ID
  field :name, types.String
  field :pets, types[PetType]
end


class PetType < GraphQL::Schema::Object
  field :id, ID, null: false
  field :name, String, null: false
  field :owner, OwnerType, null: true
end


class QueryType < GraphQL::Schema::Object
  # describe the field signature:
  field :owner, OwnerType, null: true do
    argument :id, ID, required: true
  end

  # then provide an implementation:
  def owner(id:)
    Owner.find(id)
  end
end


class Schema < GraphQL::Schema
  query QueryType
end


###   Actual Tests   ###
class ModelTest < Minitest::Test

  def test_stuff
    assert_equal('Daniel', Owner.first.name)
    assert_equal(
      ['Shelby', 'Brownie'],
      Owner.first.pets.pluck(:name)
    )

    $query = "
    {
      owner(id: 1) {
        name
        pets { name }
      }
    }"
    res = Schema.execute($query).values.first

    assert_equal(
      {
        'name' => 'Daniel',
        'pets' => [
          { 'name' => 'Shelby' },
          { 'name' => 'Brownie' },
        ],
      },
      res['owner']
    )
  end

end
