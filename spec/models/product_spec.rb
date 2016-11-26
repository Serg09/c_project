require 'rails_helper'

RSpec.describe Product, type: :model do
  let (:book) { FactoryGirl.create :book }
  let (:attributes) do
    {
      book_id: book.id,
      caption: 'Hardback', 
      sku: Faker::Code.isbn
    }
  end

  it 'can be created from valid attributes' do
    product = Product.new attributes
    expect(product).to be_valid
  end

  describe '#book_id' do
    it 'is required' do
      product = Product.new attributes.except(:book_id)
      expect(product).to have(1).error_on :book_id
    end
  end

  describe '#book' do
    it 'is a reference to the book to which the product belongs' do
      product = Product.new attributes
      expect(product.book).not_to be_nil
    end
  end

  describe '#caption' do
    it 'is required' do
      product = Product.new attributes.except(:caption)
      expect(product).to have(1).error_on :caption
    end

    it 'can be up to 256 characters long' do
      product = Product.new attributes.merge(caption: 'x' * 256)
      expect(product).to be_valid
    end

    it 'cannot be more than 256 characters' do
      product = Product.new attributes.merge(caption: 'x' * 257)
      expect(product).to have(1).error_on :caption
    end

    it 'must be unique for a given book' do
      p1 = Product.create! attributes
      p2 = Product.new attributes
      expect(p2).to have(1).error_on :caption
    end

    it 'can be duplicated across books' do
      p1 = Product.create! attributes
      other_book = FactoryGirl.create :book
      p2 = Product.new attributes.merge(book_id: other_book.id,
                                        sku: Faker::Code.isbn)
      expect(p2).to be_valid
    end
  end

  describe '#sku' do
    it 'is required' do
      product = Product.new attributes.except(:sku)
      expect(product).to have(1).error_on :sku
    end

    it 'can be up to 40 characters' do
      product = Product.new attributes.merge(sku: 'x' * 40)
      expect(product).to be_valid
    end

    it 'cannot be more than 40 characters' do
      product = Product.new attributes.merge(sku: 'x' * 41)
      expect(product).to have(1).error_on :sku
    end

    it 'must be unique' do
      p1 = Product.create! attributes
      p2 = Product.new attributes
      expect(p2).to have(1).error_on :sku
    end
  end
end
