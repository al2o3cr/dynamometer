require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  test "a model using the module can be loaded" do
    assert Person.new
  end

  test "dynamic attributes start out as empty hash" do
    @person = Person.new
    assert_equal({}, @person.dynamic_attributes)
  end

  test "has_attribute? works for both dynamic and regular attributes" do
    @person = Person.new(name: 'Nobody', magic_level: 'over 9000')
    assert @person.has_attribute?(:name)
    assert @person.has_attribute?(:magic_level)
  end

  test "getting attributes returns dynamic ones" do
    @person = Person.new(name: 'Nobody', magic_level: 'over 9000')
    attributes = @person.attributes
    assert attributes.has_key?('name')
    assert attributes.has_key?('magic_level')
    assert !attributes.has_key?('dynamic_attributes')
  end

  test "assigning attributes as a hash" do
    @person = Person.new
    @person.attributes = { name: 'Nobody', magic_level: 'over 9000' }
    assert_equal 'over 9000', @person.magic_level
    assert_equal 'Nobody', @person.name
  end

  test "reading with []" do
    @person = Person.new(name: 'Nobody', magic_level: 'over 9000')
    assert_equal 'Nobody', @person['name']
    assert_equal 'over 9000', @person['magic_level']
  end

  test "writing with []=" do
    @person = Person.new
    @person[:name] = 'Nobody'
    @person[:magic_level] = 'over 9000'
    assert_equal 'Nobody', @person.name
    assert_equal 'over 9000', @person.magic_level
  end

  test "can save without dynamic attributes" do
    @person = Person.new(name: 'Nobody in particular')
    assert @person.save
    assert_equal 'Nobody in particular', @person.name
  end

  test "can save with dynamic attributes" do
    @person = Person.new(name: 'Nobody', magic_level: 'over 9000')
    assert @person.save
    assert_equal 'over 9000', @person.magic_level
  end

  test "dynamic attributes do not shadow table attributes" do
    new_person_class = Class.new(ActiveRecord::Base) do |klass|
      klass.table_name = 'people'
      include DynamicAttributes
    end
    @person = new_person_class.new
    # NOTE: calling dynamic_attributes= will trigger the creation of
    #       attribute methods by AR. Be sneakier here.
    @person.send(:write_attribute, :dynamic_attributes, { 'name' => 'omgwtfbbq' })
    assert_not_equal 'omgwtfbbq', @person.name
  end

  test "updating a dynamic attribute marks the record as changed" do
    @person = Person.create(name: 'Nobody')
    @person.magic_level = 'over 9000'
    assert @person.changed?
  end

  test "can find records by a dynamic attribute" do
    @person = Person.create(name: 'Nobody', magic_level: 'over 9000')
    results = Person.where_dynamic_attributes(magic_level: 'over 9000')
    assert results.present?
    assert_equal @person, results.first
  end

  test "chaining does not damage original Relation" do
    original_relation = Person.where(id: 1)
    new_relation = original_relation.where_dynamic_attributes(magic_level: 'over 9000')
    duplicate_relation = Person.where(id: 1)
    assert_equal duplicate_relation.where_values, original_relation.where_values
  end
end
