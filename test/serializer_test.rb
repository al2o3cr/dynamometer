require 'test_helper'

class SerializerTest < ActiveSupport::TestCase

  def setup
    @person = Person.create(name: 'Nobody', magic_level: 'over 9000')
    @other_person = Person.create(name: 'Somebody',
                                  magic_level: 'less than that',
                                  thingy: 'not taxed')
  end

  test "it works" do
    parsed = roundtrip_json(@person)
    assert_equal @person.name, parsed['name']
    assert_equal @person.magic_level, parsed['magic_level']
    assert !parsed.has_key?('dynamic_attributes')
  end

  test "it works for late-added attributes" do
    roundtrip_json(@person)
    parsed = roundtrip_json(@other_person)
    assert_equal @other_person.name, parsed['name']
    assert_equal @other_person.magic_level, parsed['magic_level']
    assert_equal @other_person.thingy, parsed['thingy']
  end

  def roundtrip_json(o)
    json_string = o.active_model_serializer.new(o,{}).to_json
    JSON.parse(json_string)['person']
  end

end
