class User < ApplicationRecord

  has_many :answers, class_name: "Answer" , foreign_key: :author_id
  has_many :questions, class_name: "Question" , foreign_key: :author_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
