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

FactoryBot.define do
  factory :user do
    first_name { 'FirstName' }
    last_name { 'LastName' }
    sex_id { 'male' }
    birthday { 'Mon, 01 Jan 1999' }
    phone_number { '09012345678' }
    sequence(:email) { |n| "TEST#{n}@example.com" }
    password { '123456' }
    role { 'administrator' }
  end
end
