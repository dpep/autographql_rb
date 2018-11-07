require_relative 'query_builder'


module AutoGraphQL
  extend self

  @@models = {}


  def register model, options = {}
    # sanitize options
    exclude = options.fetch(:exclude, []).map(&:to_sym)
    fields = options.fetch(:fields) do
      fields = model.columns_hash.keys

      # add relationships
      fields += model.reflect_on_all_associations(
        :has_many
      ).map &:name

      fields += model.reflect_on_all_associations(
        :belongs_to
      ).map &:name
    end.map(&:to_sym) - exclude

    @@models[model] = {
      name: options.fetch(:name, model.name),
      description: options.fetch(:description, ''),
      fields: fields,
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
