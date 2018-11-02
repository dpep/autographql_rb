require_relative 'schema'


daniel = Owner.create name: 'Daniel'
daniel.pets.create name: 'Shelby'
daniel.pets.create name: 'Brownie'


bjorn = Owner.create name: 'Bjorn'
bjorn.pets.create name: 'Spot'
