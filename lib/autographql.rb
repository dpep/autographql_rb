require 'active_record'

require_relative 'autographql/autographql'


module AutoGraphQL
  VERSION = '0.0.2'
end


# make api available to all Active Record models
ActiveRecord::Base.extend AutoGraphQL::ObjectType
