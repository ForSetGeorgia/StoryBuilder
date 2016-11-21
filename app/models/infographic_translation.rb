class InfographicTranslation < ActiveRecord::Base
  belongs_to :infographic

  has_one :image,
    :conditions => "asset_type = #{Asset::TYPE[:infographic]}",
    foreign_key: :item_id,
    class_name: "Asset",
    dependent: :destroy

  has_one :dataset_file,
    :conditions => "asset_type = #{Asset::TYPE[:infographic_dataset]}",
    foreign_key: :item_id,
    class_name: "Asset",
    dependent: :destroy

  has_many :infographic_datasources, :dependent => :destroy
  accepts_nested_attributes_for :infographic_datasources

  accepts_nested_attributes_for :image, :reject_if => lambda { |c| c[:asset].blank? && c[:asset_clone_id].blank? }
  accepts_nested_attributes_for :dataset_file, :reject_if => lambda { |c| c[:asset].blank? && c[:asset_clone_id].blank? }

  attr_accessible :infographic_id, :locale, :title, :caption, :description, :dataset_url,
                  :image_attributes, :dataset_file_attributes, :infographic_datasources_attributes,
                  :subtype, :dynamic_url, :dynamic_code, :width, :height

  attr_accessor :is_progress_increment, :progress_story_id, :width, :height

  #################################
  ## Validations
  validates :title, :presence => true, length: { maximum: 255}
  # validates :image, presence: true, if: :static_type?
  validates :dataset_url, :format => {:with => URI::regexp(['http','https']), :message => I18n.t('errors.messages.invalid_format_url') }, :if => "!dataset_url.blank?"
  validates :dynamic_url, presence: true, :format => {:with => URI::regexp(['http','https']), :message => I18n.t('errors.messages.invalid_format_url') }, if: :dynamic_type?
  validate :generate_iframe
  validate :check_asset_existence
  validates_uniqueness_of :infographic_id, scope: [:locale]
  def check_asset_existence
    if static_type? && self.image.blank?
      errors.add(:image_name, I18n.t('activerecord.errors.messages.not_provided'))
    end
  end

  def generate_iframe
    if dynamic_type?
      ok = false
      html = ''
      u = self.dynamic_url
      if u.present?
        begin
          uri = URI.parse(u)
          if !(uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS))
            self.errors.add(:dynamic_url, I18n.t('stories.youtube.generate_iframe.error'))
            return false
          end
        rescue
          self.errors.add(:dynamic_url, I18n.t('stories.youtube.generate_iframe.error'))
          return false
        end
        html =  '<iframe '+(self.width.present? ? ' width="'+self.width.to_s+'"': '')+(self.height.present? ? ' height ="'+self.height.to_s+'"': '') + ' src="'+self.dynamic_url+'" frameborder="0" allowfullscreen class="infographic' + (self.height.blank? ? ' height': '') +'" sandbox="allow-scripts allow-same-origin"></iframe>'
        ok = true
      end

      if ok
        self.dynamic_code = html
        return true
      else
       self.errors.add(:dynamic_code, I18n.t('stories.youtube.generate_iframe.error'))
       return false
      end
    else
      return true
    end
  end

  #################################
  # settings to clone story
  amoeba do
    enable
    clone [:image, :dataset_file, :infographic_datasources]
  end

  #################################

  def image_exists?
    self.image.present? && self.image.file.exists?
  end

  def dataset_file_exists?
    self.dataset_file.present? && self.dataset_file.file.exists?
  end

private
  def static_type?
    self.subtype == Infographic::TYPE[:static]
  end
  def dynamic_type?
    self.subtype == Infographic::TYPE[:dynamic]
  end

end
