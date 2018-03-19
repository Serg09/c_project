require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let (:campaign) { FactoryBot.create(:campaign) }
  let (:reward) { FactoryBot.create(:reward, campaign: campaign) }
  let (:attributes) do
    {
      description: 'Endless gratitude',
      long_description: 'blah blah blah',
      minimum_contribution: 10,
      physical_address_required: true
    }
  end

  context 'for an authenticated user' do
    context 'that owns the campaign' do
      before(:each) { sign_in campaign.book.author }

      describe "GET #new" do
        it "returns http success" do
          get :new, campaign_id: campaign
          expect(response).to have_http_status(:success)
        end
      end

      describe "POST #create" do
        it "redirects to the campaign edit page" do
          post :create, campaign_id: campaign, reward: attributes
          expect(response).to redirect_to edit_campaign_path(campaign)
        end

        it 'creates a new reward record' do
          expect do
            post :create, campaign_id: campaign, reward: attributes
          end.to change(campaign.rewards, :count).by(1)
        end
      end

      context 'for a reward that is not associated with any contributions' do
        describe "GET #edit" do
          it "returns http success" do
            get :edit, id: reward
            expect(response).to have_http_status(:success)
          end
        end

        describe "patch #update" do
          it "redirects to the campaign edit page" do
            patch :update, id: reward, reward: attributes
            expect(response).to redirect_to edit_campaign_path(campaign)
          end

          it 'updates the reward' do
            expect do
              patch :update, id: reward, reward: attributes
              reward.reload
            end.to change(reward, :description).to 'Endless gratitude'
          end
        end

        describe "DELETE #destroy" do
          it "redirects to the campaign edit page" do
            get :destroy, id: reward
            expect(response).to redirect_to edit_campaign_path(campaign)
          end

          it 'removes the reward record' do
            reward # force create
            expect do
              get :destroy, id: reward
            end.to change(campaign.rewards, :count).by(-1)
          end
        end
      end

      context 'for a reward that is associated at least one contribution' do
        let (:contribution) { FactoryBot.create(:contribution, campaign: campaign) }
        let!(:fulfillment) do
          FactoryBot.create(:electronic_fulfillment, contribution: contribution,
                                                      reward: reward)
        end

        describe "GET #edit" do
          it "redirects to the user home page" do
            get :edit, id: reward
            expect(response).to redirect_to user_root_path #handled as a CanCan access exception
          end
        end

        describe "patch #update" do
          it "redirects to the user home page" do
            patch :update, id: reward, reward: attributes
            expect(response).to redirect_to user_root_path #handled as a CanCan access exception
          end

          it 'does not update the reward' do
            expect do
              patch :update, id: reward, reward: attributes
              reward.reload
            end.not_to change(reward, :description)
          end
        end

        describe "DELETE #destroy" do
          it "redirects to the campaign edit page" do
            get :destroy, id: reward
            expect(response).to redirect_to edit_campaign_path(campaign)
          end

          it 'does not remove the reward record' do
            reward # force create
            expect do
              get :destroy, id: reward
            end.not_to change(Reward, :count)
          end
        end
      end
    end

    context 'that does not own the campaign' do
      let (:other_user) { FactoryBot.create(:user) }
      before(:each) { sign_in other_user }

      describe "GET #new" do
        it "redirects to the user home page" do
          get :new, campaign_id: campaign
          expect(response).to redirect_to user_root_path
        end
      end

      describe "POST #create" do
        it "redirects to the user home page" do
          post :create, campaign_id: campaign, reward: attributes
          expect(response).to redirect_to user_root_path
        end

        it 'does not create a new reward record' do
          expect do
            post :create, campaign_id: campaign, reward: attributes
          end.not_to change(Reward, :count)
        end
      end

      describe "GET #edit" do
        it "redirects to the user home page" do
          get :edit, id: reward
          expect(response).to redirect_to user_root_path
        end
      end

      describe "patch #update" do
        it "redirects to the user home page" do
          patch :update, id: reward, reward: attributes
          expect(response).to redirect_to user_root_path
        end

        it 'does not update the reward' do
          expect do
            patch :update, id: reward, reward: attributes
            reward.reload
          end.not_to change(reward, :description)
        end
      end

      describe "DELETE #destroy" do
        it "redirects to the user home page" do
          get :destroy, id: reward
          expect(response).to redirect_to user_root_path
        end

        it 'does not delete the reward record' do
          reward # force create
          expect do
            get :destroy, id: reward
          end.not_to change(Reward, :count)
        end
      end
    end
  end

  context 'for an unauthenticated user' do
    describe "GET #new" do
      it "redirects to the sign in page" do
        get :new, campaign_id: campaign
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "POST #create" do
      it "redirects to the sign in page" do
        post :create, campaign_id: campaign, reward: attributes
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not create a new reward record' do
        expect do
          post :create, campaign_id: campaign, reward: attributes
        end.not_to change(Reward, :count)
      end
    end

    describe "GET #edit" do
      it "redirects to the sign in page" do
          get :edit, id: reward
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "patch #update" do
      it "redirects to the sign in page" do
        patch :update, id: reward, reward: attributes
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not update the reward' do
        expect do
          patch :update, id: reward, reward: attributes
          reward.reload
        end.not_to change(reward, :description)
      end
    end

    describe "DELETE #destroy" do
      it "redirects to the sign in page" do
        get :destroy, id: reward
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not delete the reward record' do
        reward # force create
        expect do
          get :destroy, id: reward
        end.not_to change(Reward, :count)
      end
    end

    describe 'GET #index' do
      context 'in JSON' do
        let!(:reward1) do
          FactoryBot.create(:reward, campaign: campaign,
                                      description: 'Total conciousness')
        end
        let!(:reward2) do
          FactoryBot.create(:reward, campaign: campaign,
                                      description: 'Sharp stick in the eye')
        end
        it 'returns the rewards for the specified campaign' do
          get :index, campaign_id: campaign, format: :json
          returned = JSON.parse(response.body, symbolize_names: true)
          expect(returned.map{|h| h[:description]}).to eq [
            'Sharp stick in the eye',
            'Total conciousness'
          ]
        end
      end
    end
  end
end
