class AddMapTemplateToTemplates < ActiveRecord::Migration
  def up
    Template.create!({id: 4, name: "map", title: "Map", description: "Minimap with map", author: "Mariam Kobuladze", public: 0, default: 0})
  end
  def down
    Template.where(id: 4).first.destroy
  end
end
