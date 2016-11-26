class Admin::ProductsController < ApplicationController
  before_action :authenticate_administrator!
  before_action :load_book, only: [:new, :create]
  layout 'admin'
  respond_to :html

  def index
    @book_versions = find_matching_titles
    @book = Book.find(params[:book_id]) if params[:book_id]
    @products = @book.products if @book
  end

  def new
    @product = @book.products.new
  end

  def create
    @product = @book.products.new product_params
    flash[:notice] = 'The product link was created successfully.' if @product.save
    respond_with @product, location: admin_book_products_path(@book)
  end

  private

  def load_book
    @book = Book.find(params[:book_id])
  end

  def find_matching_titles
    return nil unless params[:title]
    BookVersion.approved.where(['lower(title) like ?', "%#{params[:title].downcase}%"])
  end

  def product_params
    params.require(:product).permit(:caption, :sku)
  end
end
