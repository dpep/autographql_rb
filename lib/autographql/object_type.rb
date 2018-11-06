require 'graphql'
require 'set'


module AutoGraphQL
  module ObjectType
    protected

    def graphql name: self.name, description: '', fields: [], exclude: []
      # register Active Record model.  delay schema generation
      # until class and associations have been fully defined

      opts = {
        name: name,
        description: description,
        fields: fields,
        exclude: exclude,
      }

      AutoGraphQL.register self, opts
    end

  end
end
