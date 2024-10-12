GraphQL::Types::Date = Class.new(GraphQL::Schema::Scalar) do
  graphql_name 'Date'
  description 'Date formatted as YYYY-MM-DD  (ISO 8601)'

  def self.coerce_input(value, context)
    Date.parse(value)
  rescue ArgumentError
    nil
  end

  def self.coerce_result(ruby_value, context)
    ruby_value.to_s
  end
end
