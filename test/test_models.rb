require 'minitest/autorun'
require_relative '../lib/autographql'
require_relative 'support/db'


class ModelTest < Minitest::Test

  def setup
    daniel = Owner.create name: 'Daniel'
    daniel.pets.create name: 'Shelby'
    daniel.pets.create name: 'Brownie'

    bjorn = Owner.create name: 'Bjorn'
    bjorn.pets.create name: 'Spot'
  end


  def test_stuff
    assert_equal(
      ['Daniel', 'Bjorn'],
      Owner.all.pluck(:name)
    )

    assert_equal(
      ['Shelby', 'Brownie'],
      Owner.find_by(name: 'Daniel').pets.pluck(:name)
    )
  end

end
