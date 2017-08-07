class AddAuthorColumnToStoryTranslations < ActiveRecord::Migration
  def change
    add_column :story_translations, :author, :string
  end
end
