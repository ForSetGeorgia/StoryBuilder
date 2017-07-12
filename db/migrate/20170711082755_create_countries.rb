class CreateCountries < ActiveRecord::Migration
  def up
    create_table :countries do |t|
      t.boolean :has_published_stories, default: false
      t.timestamps
    end

    add_index :countries, :has_published_stories

    Country.create_translation_table! :name => :string, :permalink => :string

    add_index :country_translations, :name
    add_index :country_translations, :permalink


    create_table :story_countries do |t|
      t.integer :story_id
      t.integer :country_id

      t.timestamps
    end

    add_index :story_countries, :story_id
    add_index :story_countries, :country_id
  end

  def down
    Country.drop_translation_table!
    drop_table :countries
    drop_table :story_countries
  end
end
