class TraderMailer < ApplicationMailer
    default from: 'from@example.com'
    layout 'mailer'
  
    def account_approved_email(trader)
        @trader = trader
        mail(to: @trader.email, subject: 'Your account has been approved')
    end
  end