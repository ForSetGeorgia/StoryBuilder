class AddDescriptionToConfig < ActiveRecord::Migration
  def change
    add_column :configs, :description, :string
  end
end
