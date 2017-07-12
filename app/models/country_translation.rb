class CountryTranslation < ActiveRecord::Base
	belongs_to :country

  extend FriendlyId
  friendly_id :create_permalink, :use => :slugged, :slug_column => :permalink

  attr_accessible :country_id, :name, :permalink, :locale

  validates :name, :presence => true
  validates_uniqueness_of :country_id, scope: [:locale]

  def create_permalink
    self.name.downcase.dup.latinize.to_ascii.gsub(/[^0-9A-Za-z|_\- ]/,'')
  end


end
