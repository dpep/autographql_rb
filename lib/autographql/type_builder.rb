require 'graphql'
require 'set'


module AutoGraphQL
  module TypeBuilder
    extend self


    def build models_and_opts
      # first build all objects
      type_map = {}

      models_and_opts.each do |model, opts|
        type_map[model] = build_type model, opts
      end

      # build relationships between objects
      type_map.each do |model, type|
        relate type, models_and_opts[model][:fields], type_map
      end

      type_map
    end


    private

    def build_type model, opts
      column_types = Hash[model.columns_hash.map do |k,v|
        [ k.to_sym, convert_type(v.type) ]
      end]

      # create type
      GraphQL::ObjectType.define do
        name opts[:name]
        description opts[:description]

        opts[:fields].each do |f|
          # skip relationships
          next unless column_types[f]

          field f, column_types[f]
        end
      end
    end


    def relate type, fields, type_map
      model = type_map.key type

      belongs_to = model.reflect_on_all_associations(:belongs_to)
      has_many = model.reflect_on_all_associations(:has_many)

      (has_many + belongs_to).each do |field|
        next unless fields.include? field.name.to_sym
        next unless type_map[field.klass]

        field_type = type_map[field.klass]
        if has_many.include? field
          # make into a list
          field_type = field_type.to_list_type.to_non_null_type
        end

        # create relationship field
        gql_field = GraphQL::Field.define do
          name field.name.to_s
          type field_type
        end

        type.fields[field.name.to_s] = gql_field
      end
    end


    # convert Active Record type to GraphQL type
    def convert_type type
      case type
      when :boolean
        GraphQL::BOOLEAN_TYPE
      when :integer
        GraphQL::INT_TYPE
      when :float
        GraphQL::FLOAT_TYPE
      when :string
        GraphQL::STRING_TYPE
      when :decimal
        GraphQL::Types::DECIMAL
      when :json
        GraphQL::Types::JSON
      when :text
        GraphQL::STRING_TYPE
      when :datetime
        GraphQL::Types::ISO8601DateTime
      else
        raise TypeError.new "unsupported type: #{type}"
      end
    end


  end
end
