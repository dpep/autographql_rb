require_relative 'schema'


sf = Location.create name: 'San Francisco'
oakland = Location.create name: 'Oakland'
fresno = Location.create name: 'Fresno'

daniel = Person.create name: 'Daniel'
daniel.location = sf
daniel.age = 85
daniel.data = [ 1, 2, 3 ]
daniel.save

shelby = Pet.create name: 'Shelby', location: oakland
daniel.pets << shelby

brownie = Pet.create name: 'Brownie', location: fresno
daniel.pets << brownie


bjorn = Person.create name: 'Bjorn'
bjorn.pets.create name: 'Spot'
