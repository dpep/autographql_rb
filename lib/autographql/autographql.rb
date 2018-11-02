require 'active_record'
require 'set'


module AutoGraphQL

  module Type
    extend self

    @dbtype_map = {}

    # namespace for dynamically defined GraphQL::ObjectType subclasses

    def register model
      name = model.graphql_type.name.to_sym
      const_set name, model.graphql_type
      @dbtype_map[name] = model
    end

    def get_model type
      type = type.name if type.is_a? GraphQL::ObjectType
      @dbtype_map[type.to_sym]
    end

    def each &block
      constants.map {|c| self[c] }.each &block
    end
    alias :all :each

    def [] idx
      const_get idx
    end

  end


  def self.instances
    ActiveRecord::Base.descendants.reject do |model|
      model <= ActiveRecord::InternalMetadata
    end
  end


  # dynamically generate AutoGraphQL::QueryType
  def self.const_missing c
    super unless :QueryType == c

    Class.new GraphQL::Schema::Object do
      def self.name
        'AutoGraphQL::QueryType'
      end

      Type.each do |type|
        # define field for this type
        field type.name.downcase, type, null: true do
          # name
          argument :id, GraphQL::Types::ID, required: true
        end

        # create loader
        define_method(type.name.downcase) do |id:|
          model = AutoGraphQL::Type.get_model type
          model.find id
        end
      end
    end
  end


  def self.convert_type type
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


  module ObjectType
    protected

    def graphql_type name: self.name, description: '', fields: [], exclude: []
      columns = Hash[columns_hash.map {|k,v| [k.to_sym, v] }]
      belongs_to = reflect_on_all_associations(:belongs_to)
      # has_many = reflect_on_all_associations(:has_many)

      # figure out which active record fields to expose
      fields = Set.new(
        (fields.empty? ? columns.keys : fields).map(&:to_sym)
      )

      # remove blacklisted fields
      fields -= exclude.map(&:to_sym)

      # remove relationships for now
      fields -= belongs_to.map(&:association_foreign_key).map(&:to_sym)
      # exclude += belongs_to.map(&:association_primary_key).map(&:to_sym)


      gql_obj = GraphQL::ObjectType.define do
        name name
        description description

        fields.each do |f|
          field f, AutoGraphQL.convert_type(columns[f].type)
        end
      end

      # field = GraphQL::Field.define do

      # end

      # redefine method to return result
      define_singleton_method(:graphql_type) do
        gql_obj
      end
      # make publically available
      singleton_class.send :public, :graphql_type

      # register new GraphQL::ObjectType
      AutoGraphQL::Type.register self
    end
  end

end


# monkey patch all Record Objects to make api available
ActiveRecord::Base.extend AutoGraphQL::ObjectType
