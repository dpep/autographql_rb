require 'graphql'
require 'set'


module AutoGraphQL
  module ObjectBuilder
    extend self


    def build

      columns = Hash[columns_hash.map {|k,v| [k.to_sym, v] }]
      belongs_to = reflect_on_all_associations(:belongs_to)
      has_many = reflect_on_all_associations(:has_many)

      # figure out which active record fields to expose
      fields = Set.new(
        (fields.empty? ? columns.keys : fields).map(&:to_sym)
      )

      # remove blacklisted fields
      fields -= exclude.map(&:to_sym)

      # remove relationships for now
      fields -= belongs_to.map(&:name)
      fields -= has_many.map(&:name)


      has_many.map do |field|
        p field
      end


      # create type
      gql_obj = GraphQL::ObjectType.define do
        name name
        description description

        fields.each do |f|
          type = AutoGraphQL::ObjectType.send :convert_type, columns[f].type
          field f, type
        end
      end

      # redefine method to return result
      define_singleton_method(:graphql) do
        gql_obj
      end

      # make publically available
      singleton_class.send :public, :graphql

      # register new GraphQL::ObjectType
      AutoGraphQL.send :register, self

      gql_obj
    end


    private

    def convert_type type
      # convert Active Record type to GraphQL type
      case type
      when :boolean
        GraphQL::BOOLEAN_TYPE
      when :integer
        GraphQL::INT_TYPE
      when :float
        GraphQL::FLOAT_TYPE
      when :string
        GraphQL::STRING_TYPE
      else
        raise TypeError.new "unsupported type: #{type}"
      end
    end

  end
end
