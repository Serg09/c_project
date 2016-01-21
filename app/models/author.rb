# == Schema Information
#
# Table name: authors
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string           not null
#  first_name             :string           not null
#  last_name              :string           not null
#  phone_number           :string
#  contactable            :boolean          default(FALSE), not null
#  package_id             :integer
#  status                 :string(10)       default("pending"), not null
#

class Author < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  STATUSES = %w(pending accepted rejected)

  validates_presence_of :first_name, :last_name, :username
  validates_uniqueness_of :username
  validates_inclusion_of :status, in: STATUSES

  class << self
    STATUSES.each do |s|
      define_method s.upcase do
        s
      end
    end
  end

  STATUSES.each do |s|
    define_method "status_#{s}?" do
      self.status == s
    end
  end

  scope :pending, -> { where(status: Author.PENDING) }
  scope :accepted, -> { where(status: Author.ACCEPTED) }
  scope :rejected, -> { where(status: Author.REJECTED) }

  def full_name
    "#{first_name} #{last_name}"
  end
end
