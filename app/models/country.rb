class Country < ActiveRecord::Base
	translates :name, :permalink

	has_many :story_countries, :dependent => :destroy
	has_many :stories, :through => :story_countries
	has_many :country_translations, :dependent => :destroy
  accepts_nested_attributes_for :country_translations

  attr_accessible :id, :country_translations_attributes, :has_published_stories

	def self.sorted
		with_translations(I18n.locale).order("country_translations.name asc")
	end

  def self.with_stories
    where(:has_published_stories => true)
  end

  # update the flags for countries with published stories
  def self.update_published_stories_flags
    # get countries with published stories
    countries = Story.all_published_countries

    # update the flag values
    if countries.present?
      sql = "update countries set has_published_stories = if(id in ("
      sql << countries.map{|x| "'#{x}'"}.join(', ')
      sql << "), 1, 0)"

      connection.update(sql)
    else
      update_all(:has_published_stories => 0)
    end
  end


end
