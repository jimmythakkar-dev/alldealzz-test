class ApplicationMailer < ActionMailer::Base
  default from: "#{Settings.app_name} Support <#{Settings.email.username}>"
  layout 'mailer'
end
