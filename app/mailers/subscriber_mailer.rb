class SubscriberMailer < ApplicationMailer
  default from: 'noreply@crowdscribed.com'

  def confirmation(subscriber)
    @subscriber = subscriber
    @contact_name = 'Christian Piatt'
    @contact_title = 'President/CEO'
    @contact_email = 'christian.piatt@crowdscribed.com'
    mail to: subscriber.email, subject: 'Welcome to Crowdscribed!'
  end
end
