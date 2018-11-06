require 'graphql'
require 'set'


module AutoGraphQL
  module QueryBuilder
    extend self


    def build models
      # dynamically create a QueryType subclass
      Class.new GraphQL::Schema::Object do
        def self.name
          'AutoGraphQL::QueryType'
        end

        models.each do |model, opts|
          type = AutoGraphQL::QueryBuilder.build_type model, opts

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


    def build_type model, name:, description:, fields:, exclude:
      column_types = Hash[model.columns_hash.map do |k,v|
        [ k.to_sym, v.type ]
      end]

      belongs_to = model.reflect_on_all_associations(:belongs_to)
      has_many = model.reflect_on_all_associations(:has_many)

      # determine which active record fields to expose
      fields = Set.new(
        (fields.empty? ? column_types.keys : fields).map(&:to_sym)
      )

      # remove blacklisted fields
      fields -= exclude.map(&:to_sym)

      # remove relationships for now
      fields -= belongs_to.map(&:name)
      fields -= has_many.map(&:name)


      # create type
      GraphQL::ObjectType.define do
        name name
        description description

        fields.each do |f|
          type = AutoGraphQL::QueryBuilder.convert_type column_types[f]
          field f, type
        end
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
      else
        raise TypeError.new "unsupported type: #{type}"
      end
    end


  end
end
