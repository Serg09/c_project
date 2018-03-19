require 'rails_helper'

RSpec.describe Fulfillment, type: :model do
  let (:house_reward) { FactoryBot.create(:house_reward) }
  let (:collected_campaign) { FactoryBot.create(:collected_campaign) }
  let (:active_campaign) { FactoryBot.create(:active_campaign) }
  let (:hr) { FactoryBot.create(:reward, house_reward: house_reward, campaign: collected_campaign) }
  let (:ar1) { FactoryBot.create(:reward, campaign: collected_campaign) }
  let (:ar2) { FactoryBot.create(:reward, campaign: active_campaign) }

  let (:d1) { FactoryBot.create(:collected_contribution, campaign: collected_campaign) }
  let (:d2) { FactoryBot.create(:collected_contribution, campaign: collected_campaign) }
  let (:d3) { FactoryBot.create(:collected_contribution, campaign: collected_campaign) }
  let (:d4) { FactoryBot.create(:collected_contribution, campaign: active_campaign) }
  let (:d5) { FactoryBot.create(:collected_contribution, campaign: collected_campaign) }
  let (:d6) { FactoryBot.create(:collected_contribution, campaign: collected_campaign) }
  let (:d7) { FactoryBot.create(:cancelled_contribution, campaign: collected_campaign) }
  let (:d8) { FactoryBot.create(:collected_contribution, campaign: active_campaign) }

  let!(:f1) { FactoryBot.create(:physical_fulfillment, delivered: false, reward: hr, contribution: d1) }
  let!(:f2) { FactoryBot.create(:physical_fulfillment, delivered: false, reward: ar1, contribution: d2) }
  let!(:f3) { FactoryBot.create(:electronic_fulfillment, delivered: false, reward: hr, contribution: d3) }
  let!(:f4) { FactoryBot.create(:electronic_fulfillment, delivered: false, reward: ar2, contribution: d4) }
  let!(:f5) { FactoryBot.create(:physical_fulfillment, delivered: true, reward: hr, contribution: d5) }
  let!(:f6) { FactoryBot.create(:physical_fulfillment, delivered: true, reward: ar1, contribution: d6) }
  let!(:f7) { FactoryBot.create(:electronic_fulfillment, delivered: true, reward: hr, contribution: d7) }
  let!(:f8) { FactoryBot.create(:electronic_fulfillment, delivered: true, reward: ar2, contribution: d8) }

  describe '::undelivered' do
    it 'returns a list of fulfillments that have not been delivered' do
      expect(Fulfillment.undelivered.map(&:id)).to contain_exactly *[f1, f2, f3, f4].map(&:id)
    end
  end

  describe '::delivered' do
    it 'returns a list of fulfillments that have been delivered' do
      expect(Fulfillment.delivered.map(&:id)).to contain_exactly *[f5, f6, f7, f8].map(&:id)
    end
  end

  describe '::house' do
    it 'returns a list of fulfillments that are to be fulfilled by the company' do
      expect(Fulfillment.house.map(&:id)).to contain_exactly *[f1, f3, f5, f7].map(&:id)
    end
  end

  describe '::author' do
    let (:author) { collected_campaign.book.author }
    it 'returns a list of fulfillments that are to be fulfilled by the author' do
      expect(Fulfillment.author(author).map(&:id)).to contain_exactly *[f2, f6].map(&:id)
    end
  end

  describe '::ready' do
    it 'returns a list of fulfillments that are ready to be fulfilled (i.e., the campaign has been closed and the payment collected)' do
      expect(Fulfillment.ready.map(&:id)).to contain_exactly *[f1, f2, f3, f5, f6].map(&:id)
    end
  end
end
