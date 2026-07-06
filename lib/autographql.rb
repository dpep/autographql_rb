require 'active_record'
require 'graphql'

require_relative 'autographql/autographql'
require_relative 'autographql/object_type'
require_relative 'autographql/version'


# make api available to all Active Record models
ActiveRecord::Base.extend AutoGraphQL::ObjectType
