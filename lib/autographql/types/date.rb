GraphQL::Types::DATE = GraphQL::ScalarType.define do
  name 'DATE'
  description 'Date formatted as YYYY-MM-DD'

  coerce_result ->(value, ctx) do
    value.to_s
  end

  coerce_input ->(value, ctx) do
    begin
      Date.parse(value)
    rescue ArgumentError => e
      nil
    end
  end
end