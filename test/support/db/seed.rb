require_relative 'schema'


daniel = Person.create name: 'Daniel'
daniel.pets.create name: 'Shelby'
daniel.pets.create name: 'Brownie'


bjorn = Person.create name: 'Bjorn'
bjorn.pets.create name: 'Spot'
