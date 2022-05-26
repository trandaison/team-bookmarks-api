class UserMailer < ApplicationMailer
  default from: Settings.default_email_from

  def reset_password_email user, url: nil
    @user = user
    token = user.issue_jwt_token(type: :reset_password)
    @url = url ? "#{url}?token=#{token}" : v2_reset_password_edit_url(token: token)
    mail(to: user.email, subject: 'Reset your API Placeholder password')
  end
end
