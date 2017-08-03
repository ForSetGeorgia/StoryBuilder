class CreateConfigTable < ActiveRecord::Migration
  def up
    create_table :configs do |t|
      t.string :key, null: false, unique: true
      t.string :value
      t.string :input_type, null: false
      t.string :possible_values
      t.timestamps
    end

    Config.create({key: 'author', value: 'complex', input_type: 'radio', possible_values: '["simple","complex"]'})
    Config.create({key: 'category_publishable', value: 'true', input_type: 'boolean', possible_values: "[true,false]"})

    # require 'json'
    # text = '{"one":1,"two":2}'
    # data = JSON.parse(text)

  end

  def down
    drop_table :configs
  end
end
