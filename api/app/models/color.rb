# == Schema Information
#
# Table name: colors
#
#  id         :bigint           not null, primary key
#  color      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Color < ApplicationRecord
end
