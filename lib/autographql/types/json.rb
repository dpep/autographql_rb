GraphQL::Types::JSON = GraphQL::ScalarType.define do
  name 'JSON'

  coerce_result ->(value, ctx) do
    # TODO: handle nil case, which doesn't call coerce
    JSON.dump value
  end

  coerce_input ->(value, ctx) do
    begin
      JSON.parse value
    rescue JSON::ParserError => e
      raise GraphQL::CoercionError, e.message
    end
  end
end
