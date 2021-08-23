class VerificationsMailer < ActionMailer::Base
  def notify_email(user_id, code)
    @code = code
    @body = t(:your_access_code_is)
    @user = User.find(user_id)
    mail(:to => @user.email,
         :from => "no-reply@e-event.ir",
         :subject => t(:notification)) do |format|
      format.text
      format.html
    end
  end
end
