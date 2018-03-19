# Preview all emails at http://localhost:3000/rails/mailers/books
class BookMailerPreview < ActionMailer::Preview

  def approval
    BookMailer.approval BookVersion.approved.first || FactoryBot.create(:approved_book_version)
  end

  def rejection
    BookMailer.rejection BookVersion.rejected.first || FactoryBot.create(:rejected_book_version)
  end
end
