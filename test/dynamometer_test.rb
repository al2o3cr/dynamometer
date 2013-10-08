require 'test_helper'

class DynamometerTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Dynamometer
  end

  test "models" do
    assert Person.new
  end
end
