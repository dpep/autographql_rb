require_relative 'schema'


us = Location.create name: 'United States', founded: 'July 4, 1776'
sf = Location.create name: 'San Francisco', founded: 'June 29, 1776', location: us
oakland = Location.create name: 'Oakland', founded: 'Jan 1, 1852', location: us
fresno = Location.create name: 'Fresno', founded: 'Jan 1, 1872', location: us

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
