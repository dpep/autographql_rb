require 'graphql'
require 'set'


module AutoGraphQL
  module ObjectType
    protected

    def graphql options = {}
      # register Active Record model.  delay schema generation
      # until class and associations have been fully defined

      AutoGraphQL.register self, options
    end

  end
end
