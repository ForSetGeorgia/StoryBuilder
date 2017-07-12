class CountryTranslation < ActiveRecord::Base
	belongs_to :country

  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :permalink
  # friendly_id :name, use: :slugged, slug_column: :permalink
  # friendly_id :name, use: :slugged, slug_column: :permalink

  attr_accessible :country_id, :name, :permalink, :locale

  validates :name, :presence => true
  validates_uniqueness_of :country_id, scope: [:locale]

  def should_generate_new_friendly_id?
    name_changed?
  end
  # def required_data_provided?
  #   provided = false

  #   provided = self.name.present?

  #   return provided
  # end

  # def add_required_data(obj)
  #   self.name = obj.name if self.name.blank?
  # end
 # def should_generate_new_friendly_id?
 #  true
 #   # Rails.logger.debug("--------------------------------------------in slug generator")
 #    # if !slug?
 #    #   name_changed?
 #    # else
 #    #   false
 #    # end
 #  end

  def create_permalink
     Rails.logger.debug("--------------------------------------------permalink creatoer")
     puts "--------------------------permalink"
    self.name.downcase.dup.latinize.to_ascii.gsub(/[^0-9A-Za-z|_\- ]/,'')
  end


end
