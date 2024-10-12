describe AutoGraphQL do
  # def test_type_registration
  #   assert AutoGraphQL::ObjectTypes.include? Person.graphql
  #   assert AutoGraphQL::ObjectTypes.include? Pet.graphql
  # end

  it 'generates a schema' do
    # generate schema
    schema = Class.new GraphQL::Schema do
      query AutoGraphQL::QueryType
    end

    query = "
    {
      person(id: 1) { name }
    }"
    res = schema.execute(query).values.first

    expect(res['person']).to eq(
      {
        'name' => Person.find(1).name,
      },
    )


    query = "
    {
      pet(id: 1) { name }
    }"
    res = schema.execute(query).values.first

    expect(res['pet']).to eq(
      {
        'name' => Pet.find(1).name,
      },
    )
  end
end
