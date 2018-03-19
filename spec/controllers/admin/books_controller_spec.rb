require 'rails_helper'

RSpec.describe Admin::BooksController, type: :controller do
  let (:author) { FactoryBot.create(:author) }
  let (:genre) { FactoryBot.create(:genre) }
  let (:book) { FactoryBot.create(:book, author: author) }
  let (:attributes) do
    {
      title: 'War and Peace',
      short_description: 'It is a book.',
      long_description: 'It is a really long book about really heavy topics.',
      genres: [genre.id]
    }
  end

  context 'for an authenticated administrator' do
    let (:admin) { FactoryBot.create(:administrator) }
    before(:each) { sign_in admin }

    describe "GET #index" do
      it "returns http success" do
        get :index, author_id: author
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #new" do
      it "returns http success" do
        get :new, author_id: author
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST #create' do
      it 'redirects to the author book index page' do
        post :create, author_id: author, book: attributes
        expect(response).to redirect_to admin_author_books_path(author)
      end

      it 'creates a book record' do
        expect do
          post :create, author_id: author, book: attributes
        end.to change(Book, :count).by(1)
      end

      it 'creates an approved book version record' do
        expect do
          post :create, author_id: author, book: attributes
        end.to change(BookVersion.approved, :count).by(1)
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        get :edit, id: book
        expect(response).to have_http_status(:success)
      end
    end

    describe 'DELETE #destroy' do
      let!(:book) { FactoryBot.create(:book, author: author) }

      it 'redirects to the author books index page' do
        delete :destroy, id: book
        expect(response).to redirect_to(admin_author_books_path(author))
      end

      it 'removes the book record' do
        expect do
          delete :destroy, id: book
        end.to change(Book, :count).by(-1)
      end

      it 'removes the book version record' do
        expect do
          delete :destroy, id: book
        end.to change(BookVersion, :count).by(-1)
      end
    end
  end

  context 'for an unauthenticated user' do
    describe "GET #index" do
      it 'redirects to the home page' do
        get :index, author_id: author
        expect(response).to redirect_to root_path
      end
    end

    describe "GET #new" do
      it 'redirects to the home page' do
        get :new, author_id: author
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'redirects to the home page' do
        post :create, author_id: author, book: book
        expect(response).to redirect_to root_path
      end

      it 'does not create a book record' do
        expect do
          post :create, author_id: author, book: attributes
        end.not_to change(Book, :count)
      end

      it 'does not create a book version record' do
        expect do
          post :create, author_id: author, book: attributes
        end.not_to change(BookVersion, :count)
      end
    end

    describe "GET #edit" do
      it 'redirects to the home page' do
        get :edit, id: book
        expect(response).to redirect_to root_path
      end
    end

    describe 'DELETE #destroy' do
      let!(:book) { FactoryBot.create(:book, author: author) }

      it 'redirects to the home page' do
        delete :destroy, id: book
        expect(response).to redirect_to root_path
      end

      it 'does not remove the book record' do
        expect do
          delete :destroy, id: book
        end.not_to change(Book, :count)
      end

      it 'does not remove the book version record' do
        expect do
          delete :destroy, id: book
        end.not_to change(BookVersion, :count)
      end
    end
  end
end
