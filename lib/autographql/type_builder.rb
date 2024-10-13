# load types
Dir["#{__dir__}/types/*.rb"].each { |f| require f }


module AutoGraphQL
  module TypeBuilder
    extend self


    def build models_and_opts
      # first build all objects
      type_map = {}

      models_and_opts.each do |model, opts|
        type_map[model] = build_type model, opts
      end

      models_and_opts.each do |model, opts|
        build_type_methods type_map[model], opts[:methods], type_map
      end

      # build relationships between objects
      type_map.each do |model, type|
        relate type, models_and_opts[model][:fields], type_map
      end

      type_map
    end


    private

    def build_type model, opts
      column_types = Hash[model.columns_hash.map do |name, column|
        next nil unless opts[:fields].include? name.to_sym

        type = convert_type(column.type)
        unless type
          raise TypeError.new(
            "unsupported type: '#{column.type}' for #{model.name}::#{column.name}"
          )
        end

        [ name.to_sym, type ]
      end.compact]

      # create type
      Class.new(GraphQL::Schema::Object) do |gql_type|
        graphql_name opts[:name]
        description opts[:description]

        opts[:fields].each do |f|
          # skip relationships
          next unless column_types[f]

          field f, column_types[f]
        end
      end
    end


    def build_type_methods gql_type, methods, type_map
      methods.each do |name, type|
        name = name.to_s

        if type.is_a? Array
          list_type = true
          unless type.length == 1
            raise ArgumentError, "invalid type: #{type}"
          end

          type = type.first
        else
          list_type = false
        end

        type = if type_map.include? type
          type_map[type]
        else
          convert_type type
        end

        if list_type
          type = type.to_list_type
        end

        gql_type.fields[name] = GraphQL::Schema::Field.new(
          name: name,
          type: type,
        )
      end
    end


    def relate type, fields, type_map
      model = type_map.key type

      belongs_to = model.reflect_on_all_associations(:belongs_to)
      has_one = model.reflect_on_all_associations(:has_one)
      has_many = model.reflect_on_all_associations(:has_many)

      (belongs_to + has_one + has_many).each do |field|
        next unless fields.include? field.name.to_sym
        next unless type_map[field.klass]

        field_type = type_map[field.klass]
        if has_many.include? field
          # make into a list
          field_type = field_type.to_list_type.to_non_null_type
        end

        # create relationship field
        type.fields[field.name.to_s] = GraphQL::Schema::Field.new(
          name: field.name.to_s,
          type: field_type,
        )
      end
    end


    # convert Active Record type to GraphQL type
    def convert_type type
      return type if type.is_a?(GraphQL::Schema::Member)

      unless type.is_a?(Symbol)
        type = type.to_s.downcase.to_sym
      end

      {
        boolean: GraphQL::Types::Boolean,
        date: GraphQL::Types::Date,
        datetime: GraphQL::Types::ISO8601DateTime,
        decimal: GraphQL::Types::Decimal,
        float: GraphQL::Types::Float,
        int: GraphQL::Types::Int,
        integer: GraphQL::Types::Int,
        json: GraphQL::Types::JSON,
        string: GraphQL::Types::String,
        text: GraphQL::Types::String,
      }[type]
    end


  end
end
