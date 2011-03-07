# == Schema Information
# Schema version: 20110307144919
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  # in SQL desending order is DESC
  default_scope :order => 'microposts.created_at DESC'
end
