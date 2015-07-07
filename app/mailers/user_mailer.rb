class UserMailer < ActionMailer::Base
  default from: 'info@crantastic.org'
  default_url_options[:host] = ENV['SITE_DOMAIN']

  def activation_instructions(user)
    @user = user
    @activation_url = activate_url(@user.perishable_token)
    mail(
      content_type: 'text/html',
      to: user.email,
      subject: 'Please activate your new crantastic account'
    )
  end

  def activation_confirmation(user)
    @user = user
    mail(
      content_type: 'text/html',
      to: user.email,
      subject: 'Your crantastic account has been activated!'
    )
  end

  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(
      content_type: 'text/html',
      to: user.email,
      subject: "Password Reset Instructions"
    )
  end

end
