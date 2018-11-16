require 'active_record'

require_relative 'autographql/autographql'
require_relative 'autographql/object_type'


module AutoGraphQL
  VERSION = '0.0.4'
end


# make api available to all Active Record models
ActiveRecord::Base.extend AutoGraphQL::ObjectType
