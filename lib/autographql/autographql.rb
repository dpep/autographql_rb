require_relative 'query_builder'


module AutoGraphQL
  extend self

  @@models = {}


  def register model, options = {}
    # sanitize options

    name = options.fetch(:name, model.name)
    name.gsub! /:/, '_'

    exclude = options.fetch(:exclude, []).map(&:to_sym)

    # add 'id' column by default
    fields = [ :id ]

    # either use user specified fields or default to all
    fields += options.fetch(:fields) do
      res = model.columns_hash.keys

      # add relationships
      res += [ :has_one, :has_many, :belongs_to ].map do |type|
        model.reflect_on_all_associations(type).map &:name
      end.flatten
    end.map(&:to_sym) - exclude

    @@models[model] = {
      name: name,
      description: options.fetch(:description, ''),
      fields: fields,
      methods: options.fetch(:methods, [])
    }
  end


  # dynamically generate ::QueryType
  def const_missing const
    case const
    when :QueryType
      AutoGraphQL::QueryBuilder.build @@models
    else
      super
    end
  end


end
