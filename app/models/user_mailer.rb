class UserMailer < ActionMailer::Base
  def activation_instructions(user)
    setup_email(user)
    @activation_url = activate_url(user.perishable_token)
    mail(
      content_type: 'text/html',
      to: @user.email,
      from: 'info@crantastic.org',
      subject: 'Please activate your new crantastic account'
    )
  end

  def activation_confirmation(user)
    setup_email(user)
    mail(
      content_type: 'text/html',
      to: @user.email,
      from: 'info@crantastic.org',
      subject: 'Your crantastic account has been activated!'
    )
  end

  def password_reset_instructions(user)
    setup_email(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(
      content_type: 'text/html',
      to: @user.email,
      from: 'info@crantastic.org',
      subject: "Password Reset Instructions"
    )
  end

  protected
    def setup_email(user)
      default_url_options[:host] = APP_CONFIG[:site_domain]

      @recipients = user.email
      @from       = "Hadley Wickham <cranatic@gmail.com>"
      @sent_on    = Time.now
      @user = user
    end
end
