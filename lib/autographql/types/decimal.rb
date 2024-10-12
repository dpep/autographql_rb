GraphQL::Types::Decimal = Class.new(GraphQL::Schema::Scalar) do
  graphql_name 'Decimal'

  def self.coerce_input(value, context)
    value.to_s
  end

  def self.coerce_result(ruby_value, context)
    BigDecimal(ruby_value)
  rescue TypeError => e
    nil
  end
end

# TODO: include precision
