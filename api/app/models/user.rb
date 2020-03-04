# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birthday               :date             not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  jti                    :string           not null
#  last_name              :string           not null
#  phone_number           :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sex_id                 :integer          not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :blogposts, dependent: :destroy

  enum sex_id: { male: 1, female: 2 }, _prefix: :sex
  enum role: { viewer: 0, publisher: 1, administrator: 99 }

  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }

  validates :sex_id, presence: true
  validates :sex_id, inclusion: { in: sex_ids.keys }, allow_blank: true

  validates_date :birthday

  validates :phone_number, presence: true
  validates :phone_number, format: { with: /\A[+]*[0-9]{1,4}[-\s0-9]*\z/i }, allow_blank: true

  validates :email, presence: true
  validates :email, format: { with: Devise.email_regexp }, allow_blank: true
  validates :email, uniqueness: true

  validates :role, presence: true
  validates :role, inclusion: { in: roles.keys }, allow_blank: true
end
