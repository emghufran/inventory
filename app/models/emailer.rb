class Emailer < ActionMailer::Base
  def send_activation_request(sent_at = Time.now)

      @subject = "New User registration request"
      @recipients = 'emghufran@gmail.com'
      @from = 'explosive.inventory@gmail.com'
      @sent_on = sent_at
      @body["title"] = 'This is title'
      @body["email"] = 'sender@yourdomain.com'
      @body["message"] = "A new user has registered. Please go to http://localhost:3000/user/activation to activate users."
      @headers = {}
   end  

end
