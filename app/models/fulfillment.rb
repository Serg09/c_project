# == Schema Information
#
# Table name: fulfillments
#
#  id              :integer          not null, primary key
#  type            :string(50)       not null
#  contribution_id :integer          not null
#  reward_id       :integer          not null
#  email           :string(200)
#  address1        :string(100)
#  address2        :string(100)
#  city            :string(100)
#  state           :string(2)
#  postal_code     :string(15)
#  country_code    :string(2)
#  delivered       :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  recipient       :string(100)
#

class Fulfillment < ActiveRecord::Base
  belongs_to :contribution
  belongs_to :reward
  validates_presence_of :contribution_id, :reward_id
  validates_length_of :recipient, maximum: 100
  validates_uniqueness_of :contribution_id, message: 'This contribution already has a fulfillment'

  scope :delivered, ->{where(delivered: true)}
  scope :undelivered, ->{where(delivered: false)}
  scope :house, ->{joins(reward: :house_reward)}
  scope :ready, ->{joins(contribution: :campaign).where(campaigns: {state: 'collected'}, contributions: {state: 'collected'})}

  def self.author(author_or_id)
    id = author_or_id.respond_to?(:id) ?
      author_or_id.id :
      author_or_id
    joins(:reward, contribution: [campaign: :book]).
      where('house_reward_id is null and books.author_id = ?', id)
  end
end
