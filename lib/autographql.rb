require 'active_record'
require 'graphql'

require_relative 'autographql/autographql'
require_relative 'autographql/object_type'


module AutoGraphQL
  VERSION = Gem.loaded_specs["autographql"].version.to_s
end


# make api available to all Active Record models
ActiveRecord::Base.extend AutoGraphQL::ObjectType
