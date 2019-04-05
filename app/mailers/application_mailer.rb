class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM_NAME']
  layout 'mailer'
end
