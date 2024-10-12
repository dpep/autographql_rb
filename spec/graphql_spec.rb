describe 'GraphQL' do
    class PersonType < GraphQL::Schema::Object
      graphql_name 'Person'

      field :id, GraphQL::Types::ID
      field :name, GraphQL::Types::String
      field :pets, ["PetType"]
    end


    class PetType < GraphQL::Schema::Object
      field :id, ID, null: false
      field :name, String, null: false
      field :person, PersonType, null: true
    end


    class QueryType < GraphQL::Schema::Object
      # describe the field signature:
      field :person, PersonType, null: true do
        argument :id, ID, required: true
      end

      # then provide an implementation:
      def person(id:)
          Person.find(id)
      end
    end


    class Schema < GraphQL::Schema
      query QueryType
    end


  it 'can query a person with pets' do
    person = Person.first
    expect(person.name).to eq('Daniel')

    expect(person.pets.map(&:name)).to eq(['Shelby', 'Brownie'])

    $query = "
    {
      person(id: 1) {
        name
        pets { name }
      }
    }"
    res = Schema.execute($query).values.first

    expect(res['person']).to eq(
      {
        'name' => 'Daniel',
        'pets' => [
          { 'name' => 'Shelby' },
          { 'name' => 'Brownie' },
        ],
      },
    )
  end
end
