require 'minitest/autorun'
require 'active_record'

require_relative '../lib/autographql'
require_relative 'support/db/seed'


class AutoGQLTest < Minitest::Test

  def test_type_registration
    assert AutoGraphQL::ObjectTypes.include? Person.graphql
    assert AutoGraphQL::ObjectTypes.include? Pet.graphql
  end


  def test_basic
    # generate schema
    schema = Class.new GraphQL::Schema do
      query AutoGraphQL::QueryType
    end

    query = "
    {
      person(id: 1) { name }
    }"
    res = schema.execute(query).values.first

    assert_equal(
      {
        'name' => Person.find(1).name,
      },
      res['person']
    )


    query = "
    {
      pet(id: 1) { name }
    }"
    res = schema.execute(query).values.first

    assert_equal(
      {
        'name' => Pet.find(1).name,
      },
      res['pet']
    )
  end

end
