class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable


  # find the facebook oauth record, or create new record.
  def self.find_for_facebook_oauth(auth)
    User.where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      #user.name = auth.extra.raw_info.name
      user.name = auth.info.name
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      # user.image = auth.info.image
      user.save!
    end
  end

  # find the twitter oauth record, or create new record.
  def self.find_for_twitter_oauth(auth)
    User.where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.name = auth.info.nickname
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = self.create_unique_email
      user.password = Devise.friendly_token[0,20]
      # user.image = auth.info.image
      user.save!
    end
  end


  def self.create_unique_string
      SecureRandom.uuid
    end
   
  def self.create_unique_email
    self.create_unique_string + "@example.com"
  end

end
