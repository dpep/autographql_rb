require_relative 'query_builder'


module AutoGraphQL
  extend self

  @@models = {}


  def register model, options = {}
    # sanitize options
    @@models[model] = {
      name: options.fetch(:name, model.name),
      description: options.fetch(:description, ''),
      fields: options.fetch(
        :fields,
        model.columns_hash.keys
      ).map(&:to_sym),
      exclude: options.fetch(:exclude, []).map(&:to_sym),
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
