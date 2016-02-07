namespace :seed do

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  desc 'Create a certain number of inquiries. (COUNT=10)'
  task inquiries: :environment do
    count = (ENV['COUNT'] || 10).to_i
    logger.info "creating #{count} inquiries"
    (0..count).each do
      i = FactoryGirl.create(:inquiry)
      logger.debug "created #{i.inspect}"
    end
  end

  desc 'Create a certain number of authors. (COUNT=10)'
  task authors: :environment do
    count = (ENV['COUNT'] || 10).to_i
    logger.info "creating #{count} authors"
    (0..count).each do
      i = FactoryGirl.create(:author)
      logger.debug "created #{i.inspect}"
    end
  end

  desc 'Create an administrator account'
  task administrator: :environment do
    attributes = {
      email: 'admin@cs.com',
      password: 'please01',
      password_confirmation: 'please01'
    }
    amdin = Administrator.find_by(email: 'admin@cs.com')
    if admin.present?
      logger.info "Administrator already exists"
    else
      admin = Administrator.create!(attributes)
      logger.info "created administrator account #{admin.inspect}"
    end
  end
end