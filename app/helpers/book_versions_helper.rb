module BookVersionsHelper
  def dynamic_edit_path(book_version)
    if book_version.book.pending_version
      edit_book_version_path(book_version.book.pending_version)
    else
      new_book_book_version_path(book_version.book)
    end
  end

  def product_data(book_version)
    JSON.generate(book_version.products.map do |p|
      p.as_json only: [:sku, :caption]
    end)
  end
end
