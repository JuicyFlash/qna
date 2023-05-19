class User < ApplicationRecord

  has_many :answers, class_name: "Answer" , foreign_key: :author_id
  has_many :questions, class_name: "Question" , foreign_key: :author_id
  has_many :rewards
  has_many :comments, class_name: "Comment" , foreign_key: :user_id
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
