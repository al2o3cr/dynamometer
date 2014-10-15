# Dynamometer

Adds dynamic attributes to ActiveRecord models

## Usage

Generate a migration to enable hstore

    class EnableHstore < ActiveRecord::Migration
      def up
        enable_extension "hstore"
      end
    
      def down
        disable_extension "hstore"
      end
    end
    
Add a dynamic_attributes hstore when creating a table

    create_table :users do |t|
      t.hstore :dynamic_attributes
      t.index :dynamic_attributes
    end
    
or add dynamic_attributes to an existing table

    add_column :users, :dynamic_attributes, :hstore
    add_index :users, :dynamic_attributes

Add dynamic attributes to your ActiveRecord model

    class User < ActiveRecord::Base
      include DynamicAttributes
    end

## Accessors

You can read dynamic attributes like you would typical attributes.

    user.category
    user[:category]
    user['category']

You can write dynamic attributes like you would typical attributes, as well.

    user.category = 'superuser'
    user[:category] = 'superuser'
    user['category'] = 'superuser'
    user.update_attribute(:category, 'superuser')
    user.update_attributes(category: 'superuser')

Dynamic attributes will appear in your model's attributes `user.attributes` as if they were typical database attributes.

You can access just the dynamic attributes by calling `dynamic_attributes`.

## Validating

You can validate dynamic attributes if you declare them in your model:

    class Person < ActiveRecord::Base
      include DynamicAttributes

      dynamic_attributes :hometown
      validates_length_of :hometown, minimum: 2, allow_nil: true
    end

Attempting to validate undeclared dynamic attributes will fail with NoMethodError if
the attribute hasn't been set at all; don't do that.

## Querying

You can query for matches to dynamic attributes just like regular attributes.

    current_site.users.where(category: 'superuser')
    current_site.users.where(category: 'superuser', name: 'Steve')

You can also query for matches to dynamic attributes by calling
`where_dynamic_attributes`. Unlike `where` above, this will not work if you
mix dynamic and regular attributes.

    current_site.users.where_dynamic_attributes(category: 'superuser')

## ActiveModel Serializers

If you want to serialize all of your dynamic attributes using activemodel serializers

    class UserSerializer < ActiveModel::Serializer
      include DynamicAttributesSerializer
      attributes :id
    end

## Strong Parameters

To specify that dynamic attributes should be allowed using strong parameters,
include the `PermitDynamic` concern in your controller and specify the model
to be checked against.

    class PeopleController < ApplicationController
      include PermitDynamic

      def create
        @person = Person.create(person_params)
        render json: @person
      end

      private

      def person_params
        params.require(:person).permit(:name, dynamic_attributes: Person)
      end
    end

This will permit any parameters that are NOT valid regular attributes of `Person`.

## Installation

Add this line to your application's Gemfile:

    gem 'dynamometer'

And then execute:

    $ bundle

## Using Outside Rails

Dynamometer can be used outside of Rails with a few minor differences.

### Explicitly Qualify Included Modules

Outside Rails, the included modules in `app/models/concerns` and `app/controllers/concerns` are not
available. Instead, use their fully-qualified names:

    class Person < ActiveRecord::Base
      include Dynamometer::DynamicAttributes
      
      dynamic_attributes :hometown
      validates_length_of :hometown, minimum: 2, allow_nil: true
    end

and:

    class PeopleController < ApplicationController
      include Dynamometer::PermitDynamic
      
      def create
        @person = Person.create(person_params)
        render json: @person
      end
      
      private
      
      def person_params
        params.require(:person).permit(:name, dynamic_attributes: Person)
      end
    end

For the controller case, you'll also need to `require 'dynamometer/permit_dynamic'` someplace in your environment.

### Activate the ActiveRecord integration

Somewhere in your initialization code after `ActiveRecord::Base` has been loaded, call `Dynamometer.attach` to
enable dynamic attributes.

