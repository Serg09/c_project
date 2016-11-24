class Admin::ProductsController < ApplicationController
  before_action :authenticate_administrator!
  layout 'admin'

  def index
    @book_versions = find_matching_titles
    @book = Book.find(params[:book_id]) if params[:book_id]
    @products = @book.products if @book
  end

  private

  def find_matching_titles
    return nil unless params[:title]
    BookVersion.approved.where(['lower(title) like ?', "%#{params[:title].downcase}%"])
  end
end
