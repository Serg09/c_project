# Preview all emails at http://localhost:3000/rails/mailers/bios
class BioMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/bios/approval
  def approval
    BioMailer.approval Bio.approved.first || FactoryBot.create(:approved_bio)
  end

  # Preview this email at http://localhost:3000/rails/mailers/bios/rejection
  def rejection
    BioMailer.rejection Bio.rejected.first || FactoryBot.create(:rejected_bio)
  end

  private

  def sample_bio
    Bio.pending.first || FactoryBot.create(:bio)
  end
end
