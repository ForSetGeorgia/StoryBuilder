class YoutubeTranslation < ActiveRecord::Base
  belongs_to :youtube

  attr_accessible :id, :youtube_id, :locale, :title, :url, :menu_lang, :cc, :cc_lang, :code

  attr_accessor :is_progress_increment, :progress_story_id

  #################################
  ## Validations
  validates :title, :presence => true, length: { maximum: 255}  
  validates :url, :presence => true
  validates :url, :format => {:with => URI::regexp(['http','https'])}, :if => "!url.blank?"

  #################################
  # settings to clone story
  amoeba do
    enable
  end

  # #################################
  # ## Callbacks

  before_save :generate_iframe
  def generate_iframe
    logger.debug "@@@@@@@@@@@@@@@2 generate_iframe"
    id = ''
    html = ''
    ok = false
    u = self.url 
    api_key = ENV['STORY_BUILDER_YOUTUBE_API_KEY']
    if api_key.nil?
      logger.debug "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
      logger.debug "@@@@@@@@@@@@@@@ you need to register STORY_BUILDER_YOUTUBE_API_KEY ENV key"
      logger.debug "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
       self.errors.add(:code, "value can't be generated due to missing API key.")
       return false
    end
    if u.present?
      uri = URI.parse(u)
      if(uri.host.nil? && u.length == 11)
        id = u
      else
        uri = /^(?:http(?:s)?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:(?:watch)?\?(?:.*&)?v(?:i)?=|(?:embed|v|vi|user)\/))([^\?&\"'>]+)/.match(u)
        if(uri[1].length == 11)
          id = uri[1]
        end
      end
      if id.length == 11    
        source = "https://www.googleapis.com/youtube/v3/videos?key=#{api_key}&part=id&id=#{id}"
        result = JSON.parse(Net::HTTP.get_response(URI.parse(source)).body)

        pars = (self.youtube.loop ? 'loop=1' : '') + (self.youtube.info == false ? '&shoswinfo=0' : '') +
          (self.cc ? '&cc_load_policy=' + (self.cc ? '1' : '0') : '') + 
          (Language.select{|x| x.locale == self.menu_lang}.length > 0 ? '&hl=' + self.menu_lang : '') + 
          (Language.select{|x| x.locale == self.cc_lang}.length > 0 ? '&cc_lang_pref=' + self.cc_lang : '')
        pars.slice!(0) if pars[0]=='&'

        logger.debug "@@@@@@@@@@@@@@@2 result = #{result}"

          if result['items'].present?
            html =  '<iframe width="640" height="360" src="http://www.youtube.com/embed/' + 
                  id + '?' + pars + '" frameborder="0" allowfullscreen class="embed-video embed-youtube"></iframe>' 
            ok = true
          end
      end
    end   
    if ok       
      self.code = html
    else
      logger.debug "@@@@@@@@@@@@@@@2 generate_iframe error!"
       self.errors.add(:code, "value can't be generated.")
       return false
    end
    logger.debug "@@@@@@@@@@@@@@@2 generate_iframe end"
  end

end
