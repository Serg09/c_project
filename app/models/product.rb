# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  book_id    :integer          not null
#  caption    :string(256)      not null
#  sku        :string(40)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Product < ActiveRecord::Base
  belongs_to :book
  validates_presence_of :book_id, :caption, :sku
  validates_length_of :caption, maximum: 256
  validates_length_of :sku, maximum: 40
  validates_uniqueness_of :sku
  validates_uniqueness_of :caption, scope: :book_id
end
