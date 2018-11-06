require_relative 'query_builder'


module AutoGraphQL
  extend self

  @@models = {}


  def register model, opts
    @@models[model] = opts
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
