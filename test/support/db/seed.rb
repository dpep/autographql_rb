require_relative 'schema'


sf = Location.create name: 'San Francisco'

daniel = Person.create name: 'Daniel'
daniel.pets.create name: 'Shelby'
daniel.pets.create name: 'Brownie'
daniel.location = sf
daniel.age = 85
daniel.data = [ 1, 2, 3 ]
daniel.save


bjorn = Person.create name: 'Bjorn'
bjorn.pets.create name: 'Spot'
