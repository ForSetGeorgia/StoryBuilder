class StoryCountry < ActiveRecord::Base
  belongs_to :story
  belongs_to :country

  attr_accessible :story_id, :country_id

  validates :story_id, :country_id, :presence => true

  after_commit :update_country_flag

  def update_country_flag
    flag = true
    flag = self.country.story_countries.length > 0 if self.destroyed?
    self.country.update_attributes(has_published_stories: flag)
    return true
  end
end
