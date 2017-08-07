class CreateConfigTable < ActiveRecord::Migration
  def up
    create_table :configs do |t|
      t.string :key, null: false, unique: true
      t.string :value
      t.string :input_type, null: false
      t.string :possible_values
      t.timestamps
    end
  end

  def down
    drop_table :configs
  end
end
