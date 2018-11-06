require 'graphql'
require 'set'

require_relative 'type_builder.rb'


module AutoGraphQL
  module QueryBuilder
    extend self


    def build models_and_opts
      # dynamically create a QueryType subclass
      Class.new GraphQL::Schema::Object do
        def self.name
          'AutoGraphQL::QueryType'
        end

        type_map = Hash[models_and_opts.map do |model, opts|
          [
            model,
            AutoGraphQL::TypeBuilder.build(model, opts)
          ]
        end]


        type_map.each do |model, type|
          # define field for this type
          field type.name.downcase, type, null: true do
            argument :id, GraphQL::Types::ID, required: true
          end

          # create loader
          define_method(type.name.downcase) do |id:|
            model.find id
          end
        end
      end

    end


  end
end
