require 'set'

require_relative 'object_type'


module AutoGraphQL
  extend self

  @@models = Set.new


  # dynamically generate ::QueryType and ::ObjectTypes
  def const_missing const
    super unless [ :QueryType, :ObjectTypes ].include? const

    if :ObjectTypes == const
      return @@models.map(&:graphql)
    end

    Class.new GraphQL::Schema::Object do
      def self.name
        'AutoGraphQL::QueryType'
      end

      @@models.each do |model|
        type = model.graphql

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


  ## private

  def register model
    @@models << model
  end
  private_class_method :register

end
