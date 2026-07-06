# Copilot Instructions

## Project Overview

`autographql` is a Ruby gem that automagically generates GraphQL types and queries for Active Record models. Calling `graphql` (or `AutoGraphQL.register`) on a model builds a corresponding `GraphQL::Schema::Object` type and query fields.

## Repository Structure

```
lib/
  autographql.rb              # Entry point: requires deps and extends ActiveRecord::Base
  autographql/
    autographql.rb            # Core module: model registration and type generation
    object_type.rb            # `graphql` class method mixed into Active Record models
    type_builder.rb           # Builds GraphQL object types from model columns
    query_builder.rb          # Builds query fields (find by id/attributes, plural queries)
    types/                    # Custom scalar types (Date, Decimal)
    version.rb                # Gem version constant
spec/
  autographql_spec.rb         # Registration and type generation tests
  graphql_spec.rb             # Query execution tests
  models_spec.rb              # Model integration tests
  support/                    # In-memory sqlite schema, models, and seed data
autographql.gemspec           # Gem specification
```

## Development Setup

```bash
bundle install
```

## Running Tests

```bash
bundle exec rspec
```

Tests use an in-memory sqlite database defined in `spec/support/`.

## Code Style

- Follow existing Ruby conventions in the codebase
- No linter is configured; match the style of surrounding code

## Dependencies

- `activerecord`, `graphql` (runtime)
- `rspec`, `simplecov`, `sqlite3`, `debug` (development/test only)
