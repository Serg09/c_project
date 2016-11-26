# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  first_name :string(100)      not null
#  last_name  :string(100)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Author < ActiveRecord::Base
  include NamedThing

  has_one :bio, as: :author
  has_many :books, as: :author

  alias_method :active_bio, :bio
  validates_presence_of :first_name, :last_name
  validates_length_of [:first_name, :last_name], maximum: 100
  validates_uniqueness_of :first_name, scope: :last_name

  scope :by_name, ->{order(:last_name, :first_name)}
end
