require 'graphql'
require 'set'

require_relative 'type_builder.rb'


module AutoGraphQL
  module QueryBuilder
    extend self


    def build type_map
      # dynamically create a QueryType subclass
      Class.new GraphQL::Schema::Object do
        def self.name
          'AutoGraphQL::QueryType'
        end

        type_map.each do |model, type|
          # for each model, create an lookup function by ID
          name = type.graphql_name.downcase

          # define field for this type
          field name, type, null: true do
            argument :id, GraphQL::Types::ID, required: true
          end

          # create loader
          define_method(name) do |id:|
            model.find id
          end
        end
      end

    end
  end
end
