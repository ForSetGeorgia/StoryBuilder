class Country < ActiveRecord::Base
	translates :name, :permalink

	has_many :story_countries, :dependent => :destroy
	has_many :stories, :through => :story_countries
	has_many :country_translations, :dependent => :destroy
  accepts_nested_attributes_for :country_translations

  attr_accessible :id, :name, :country_translations_attributes, :has_published_stories

	def self.sorted
		with_translations(I18n.locale).order("country_translations.name asc")
	end

  def self.with_stories
    where(:has_published_stories => true)
  end

end
