class EmailHelper < ActionMailer::Base

    def send_mail(email)
      mailto(to: email[:recipient], subject: email[:subject])
    end
  
end

