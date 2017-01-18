class AddSubtitleToBookVersion < ActiveRecord::Migration
  def change
    add_column :book_versions, :subtitle, :string
  end
end
