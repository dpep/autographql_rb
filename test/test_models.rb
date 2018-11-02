require 'minitest/autorun'

require_relative '../lib/autographql'
require_relative 'support/db/seed'


class ModelTest < Minitest::Test

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
