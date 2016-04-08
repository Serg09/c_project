# == Schema Information
#
# Table name: payment_transactions
#
#  id         :integer          not null, primary key
#  payment_id :integer          not null
#  intent     :string(20)       not null
#  state      :string(20)       not null
#  response   :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PaymentTransaction < ActiveRecord::Base
  belongs_to :payment

  INTENTS = %w(sale authorize order)
  class << self
    INTENTS.each do |intent|
      define_method intent.upcase do
        intent
      end
    end
  end

  STATES = %w(created approved failed canceled expired pending)
  class << self
    STATES.each do |state|
      define_method state.upcase do
        state
      end
    end
  end

  validates_presence_of :payment_id, :intent, :state, :response
  validates_inclusion_of :intent, in: INTENTS
end
