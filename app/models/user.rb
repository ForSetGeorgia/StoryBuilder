class User < ActiveRecord::Base
  # part of liking system
  acts_as_voter

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	# :registerable, :recoverable,
  has_many :story_users
  has_many :stories, :through => :story_users, :dependent => :destroy

	has_one :local_avatar,
	  :conditions => "asset_type = #{Asset::TYPE[:user_avatar]}",
	  foreign_key: :item_id,
    class_name: "Asset",
	  dependent: :destroy

	accepts_nested_attributes_for :local_avatar, :reject_if => lambda { |c| c[:asset].blank? }

  devise :database_authenticatable,:registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role,
                  :provider, :uid, :nickname, :avatar,
                  :about, :default_story_locale, :permalink, :local_avatar_attributes, :email_no_domain,
                  :wants_notification, :notification_language#, :avatar_file_name

  attr_accessor :send_notification

#  has_permalink :create_permalink, true

  validates :role, :presence => true

  ROLES = {:user => 0, :coordinator => 50, :user_manager => 70, :site_admin => 80, :admin => 99}

  before_create :create_email_no_domain
#  before_save :check_nickname_changed
#	before_save :generate_avatar_file_name
  before_save :set_notification_language
  after_save :assign_stories

  # if a user's role changes and is at least a coordinator,
  # make sure they have access to all stories by adding them to story user
  # if the role is user, make sure they have no access to any stories in story user
  def assign_stories
    if self.role_changed?
      if self.role == ROLES[:user]
        # remove all records
        StoryUser.where(user_id: self.id).delete_all
      elsif role?(ROLES[:coordinator])
        # add all story records
        # it is possible that they already had some stories, so only add stories that they did not have
        self.stories << Story.select(:id).where('id not in (select story_id from story_users where user_id = ?)', self.id)
      end
    end
  end

  # email_no_domain is used in the search for collaborators
  # so people cannot search using domain name to guess their email addresses
  def create_email_no_domain
    self.email_no_domain = self.email.split('@').first
    return true
  end

  # if the nickname changes, then the permalink must also change
  def check_nickname_changed
    #logger.debug "************** checking nickname changed"

    # if this is a create (id does not exist) make sure the nickname is unique
    fix_nickname_duplication if self.id.blank?

    # if nickname changed text, not just case, create new permalink
    new_nickname = ActionController::Base.helpers.strip_links(self.nickname)
    nickname_was = self.nickname_was.present? ? self.nickname_was.downcase.strip : nil
    #logger.debug "************** nickname was: #{self.nickname_was}; nickname now: #{new_nickname}"
    if nickname_was != new_nickname.downcase.strip
      #logger.debug "************** nickname changed, creating new permalink"
      # make sure there are no tags in the nickname
      self.nickname = new_nickname
      self.generate_permalink!
    end
    return true
  end

  # if this nickname already exists, add a # to the end to make it unique
  def fix_nickname_duplication
    #logger.debug "************** fix_nickname_duplication "
    # if the nickname does not exist, populate with the first part of the email
    if read_attribute(:nickname).blank?
      self.nickname = self.email.split('@')[0]
    end

    n = User.where(["nickname = ?", self.nickname]).count

    if n > 0
      links = User.where(["nickname LIKE ?", "#{self.nickname}%"]).order("id")
      number = 0

      links.each_with_index do |link, index|
        if link.nickname =~ /#{self.nickname}-\d*\.?\d+?$/
          new_number = link.nickname.match(/-(\d*\.?\d+?)$/)[1].to_i
          number = new_number if new_number > number
        end
      end
      self.nickname = "#{self.nickname}-#{number+1}"
    end
    #logger.debug "************** fix_nickname_duplication nickname now: #{self.nickname} "
  end

  def create_permalink
    self.nickname.present? ? self.nickname.dup : nil
  end

  # see if the user logs in via a provider (e.g., facebook)
  # and has an avatar url from that provider
  def has_provider_avatar?
    self.provider.present? && self.avatar.present?
  end

  # see if the user has a local avatar saved
  def local_avatar_exists?
    self.local_avatar.present? && self.local_avatar.file.exists?
  end

  # get the url to the avatar
  # - check if using a provider and if so return that avatar url
  # - else use the local avatar
  # if neither exists, return the missing url
  def avatar_url(style = :'50x50')
    if has_provider_avatar? && !local_avatar_exists?
      # append the size to the end of the avatar url so the provider returns the size we want
      sizes = style.to_s.split('x')
      if sizes.length == 2
        a = self.avatar.dup
        a << '?width='
        a << sizes[0]
        a << '&height='
        a << sizes[1]
        a
      else
        self.avatar
      end
    elsif local_avatar_exists?
      self.local_avatar.file.url(style)
    else
      Asset.new(:asset_type => Asset::TYPE[:user_avatar]).file.url(style)
    end
  end


  # # create a random string for this user that will
  # # be used for the filename for the avatar
  # def generate_avatar_file_name
  #   if self.avatar_file_name.blank?
  #     self.avatar_file_name = SecureRandom.urlsafe_base64
  #   end
  #   return true
  # end


  def self.no_admins
    where("role != ?", ROLES[:admin])
  end

	# if no role is supplied, default to the basic user role
	def check_for_role
		self.role = ROLES[:user] if self.role.nil?
	end

  # use role inheritence
  # - a role with a larger number can do everything that smaller numbers can do
  def role?(base_role)
    if base_role && ROLES.values.index(base_role)
      return base_role <= self.role
    end
    return false
  end

  def role_name
    name = ''
    index = ROLES.values.index(self.role)
    if index.present?
      name = ROLES.keys[index].to_s
    end
    return name
  end

  def nickname
    read_attribute(:nickname).present? ? read_attribute(:nickname) : self.email.present? ? self.email.strip.split('@')[0] : nil
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(  nickname: auth.info.nickname,
                           provider: auth.provider,
                           uid: auth.uid,
                           email: auth.info.email.present? ? auth.info.email : "<%= Devise.friendly_token[0,10] %>@temp.com",
                           avatar: auth.info.image,
                           password: Devise.friendly_token[0,20]
                           )
    end
    user
  end

  # if login fails with omniauth, sessions values are populated with
  # any data that is returned from omniauth
  # this helps load them into the new user registration url
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

	# if user logged in with omniauth, password is not required
	def password_required?
		super && provider.blank?
	end

  # if not set, default to current locale
  def set_notification_language
    self.notification_language = I18n.locale if self.has_attribute?('notification_language') && read_attribute("notification_language").blank?
    return true
  end

  # get the notification language locale for a user
  def self.get_notification_language_locale(id)
    x = select('notification_language').find_by_id(id)
    return x.present? ? x.notification_language.to_sym : I18n.default_locale
  end

  # get list of authors this user is following
  def following_authors
    following = []
    # get notifications
    notifications = Notification.where(:user_id => self.id, :notification_type => Notification::TYPES[:published_story_by_author])
    if notifications.present?
      # get user object for each user following
      following = Author.where(:id => notifications.map{|x| x.identifier}.uniq)
    end

    return following
  end

  # get all users in the provided role
  def self.with_role(role)
    where(:role => role).order('nickname, email')
  end

  # get all users that have at least this provided role
  def self.with_at_least_role(role)
    where('role >= :role', role: role)
  end
end
