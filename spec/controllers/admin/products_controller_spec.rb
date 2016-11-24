require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  context 'for an authenticated administrator' do
    let (:admin) { FactoryGirl.create :administrator }
    before { sign_in admin }

    describe 'get :index' do
      it 'is successful' do
        get :index
        expect(response).to have_http_status :success
      end
    end
  end

  context 'for an unauthenticated user' do
    describe 'get :index' do
      it 'redirects to the home page' do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end
end
