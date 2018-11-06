require 'graphql'
require 'set'


module AutoGraphQL
  module TypeBuilder
    extend self


    def build model, opts
      # determine which active record fields to expose
      fields = Set.new(opts[:fields])

      # remove blacklisted fields
      fields -= opts[:exclude].map(&:to_sym)

      column_types = Hash[model.columns_hash.map do |k,v|
        [ k.to_sym, convert_type(v.type) ]
      end]

      # create type
      GraphQL::ObjectType.define do
        name opts[:name]
        description opts[:description]

        fields.each do |f|
          field f, column_types[f]
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
