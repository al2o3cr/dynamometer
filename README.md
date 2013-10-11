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

## Querying

You can query for matches to dynamic_attributes by calling `where_dynamic_attributes`. 

    current_site.users.where_dynamic_attributes(category: 'superuser')
    current_site.users.where_dynamic_attributes(category: 'superuser', name: 'Steve')

## ActiveModel Serializers

If you want to serialize all of your dynamic attributes using activemodel serializers

    class UserSerializer < ActiveModel::Serializer
      include DynamicAttributesSerializer
      attributes :id
    end

## Installation

Add this line to your application's Gemfile:

    gem 'dynamometer'

And then execute:

    $ bundle
