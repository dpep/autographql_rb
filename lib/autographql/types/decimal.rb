GraphQL::Types::DECIMAL = GraphQL::ScalarType.define do
  name 'DECIMAL'

  coerce_result ->(value, ctx) do
    value.to_s
  end

  coerce_input ->(value, ctx) do
    begin
      BigDecimal(value)
    rescue TypeError => e
      nil
    end
  end
end

# TODO: include precision
