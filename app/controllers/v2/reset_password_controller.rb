class V2::ResetPasswordController < V2::BaseController
  before_action :set_user, only: %i[edit update]

  def edit
  end

  def update
    password = params.dig(:user, :password).to_s
    password_confirmation = params.dig(:user, :password_confirmation).to_s
    if password.blank?
      @user.errors.add(:password, :blank)
      render :edit
      return;
    end

    if (password != password_confirmation)
      @user.errors.add(:password_confirmation, 'does not match')
      render :edit
      return;
    end

    @user.update(password: password, reset_password_token: nil)
    if @user.save
      flash[:success] = 'Password was successfully updated.'
      render :edit
    else
      render :edit
    end
  end

  private

  def decoded_token
    JWT.decode(params[:token], ENV['JWT_SECRET'], true, algorithm: 'HS256')
  rescue
    flash[:danger] = 'Invalid URL or it has been expired.'
    render :edit
  end

  def set_user
    reset_password_token = decoded_token[0]['reset_password_token']
    raise ActiveRecord::RecordNotFound unless reset_password_token
    @user = User.find_by!(reset_password_token: reset_password_token)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'This URL has been used already.'
  end
end
