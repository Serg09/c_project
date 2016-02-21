require 'rails_helper'

RSpec.describe BookVersion, type: :model do
  let (:book) { FactoryGirl.create(:book) }
  let (:image_file) { Rails.root.join('spec', 'fixtures', 'files', 'author_photo.jpg') }
  let (:sample_file) { Rails.root.join('spec', 'fixtures', 'files', 'sample.pdf') }
  let (:attributes) do
    {
      book_id: book.id,
      title: 'About Me',
      short_description: "It's about me",
      long_description: Faker::Lorem.paragraph
    }
  end

  it 'can be created from valid attributes' do
    book_version = BookVersion.new attributes
    expect(book_version).to be_valid
  end

  describe '#book' do
    it 'is required' do
      book = BookVersion.new attributes.except(:book_id)
      expect(book).to have_at_least(1).error_on :book
    end
  end

  describe '#author' do
    it 'is a reference to the author that owns the book' do
      book = BookVersion.new attributes
      expect(book.author).not_to be_nil
    end
  end

  describe '#title' do
    it 'is required' do
      book = BookVersion.new attributes.except(:title)
      expect(book).to have_at_least(1).error_on :title
    end

    it 'cannot be more than 255 characters' do
      book = BookVersion.new attributes.merge title: "x" * 256
      expect(book).to have_at_least(1).error_on :title

      book = BookVersion.new attributes.merge title: "x" * 255
      expect(book).to be_valid
    end
  end

  describe '#short_description' do
    it 'is required' do
      book = BookVersion.new attributes.except :short_description
      expect(book).to have_at_least(1).error_on :short_description
    end

    it 'cannot be more than 1000 characters' do
      book = BookVersion.new attributes.merge short_description: "x" * 1001
      expect(book).to have_at_least(1).error_on :short_description

      book = BookVersion.new attributes.merge short_description: "x" * 1000
      expect(book).to be_valid
    end
  end

  describe '#cover_image_file' do
    it 'creates a new image record in the database' do
      expect do
        book = BookVersion.new attributes.merge(cover_image_file: image_file)
        book.save!
      end.to change(Image, :count).by 1
    end

    it 'creates a new image_binary record in the database' do
      expect do
        book = BookVersion.new attributes.merge(cover_image_file: image_file)
        book.save!
      end.to change(ImageBinary, :count).by 1
    end

    it 'sets the cover_image_id value of the book record' do
      book = BookVersion.new attributes.merge(cover_image_file: image_file)
      book.save!
      expect(book.cover_image_id).not_to be_nil
    end
  end

  describe '#genres' do
    let!(:g1) { FactoryGirl.create(:genre) }
    let!(:g2) { FactoryGirl.create(:genre) }

    it 'is a list of genres to which the book belongs' do
      book = BookVersion.new attributes
      expect(book).to have(0).genres
    end
  end

  describe '#sample_file' do
    it 'creates a new image record in the database' do
      expect do
        book = BookVersion.new(attributes.merge(sample_file: sample_file))
        book.save!
      end.to change(Image, :count).by(1)
    end

    it 'creates a new image_binary record in the database' do
      expect do
        book = BookVersion.new(attributes.merge(sample_file: sample_file))
        book.save!
      end.to change(ImageBinary, :count).by(1)
    end

    it 'sets the sample_id field for the book record' do
      book = BookVersion.new(attributes.merge(sample_file: sample_file))
      book.save!
      expect(book.sample_id).not_to be_nil
    end
  end

  describe '::pending' do
    it 'returns the book versions with a status of "pending"' do
      expect(BookVersion.pending.count).to eq 0
    end
  end
end
