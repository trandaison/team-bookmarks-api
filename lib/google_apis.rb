class GoogleApis
  attr_reader :token_type, :access_token

  def initialize(token_type, access_token)
    @token_type = token_type
    @access_token = access_token
  end

  def user_info
    response = HTTParty.get(Settings.googleapis.oauth2.userinfo, headers: authorization_header)
    return nil unless response.code == 200

    user = User.find_or_initialize_by(email: response.parsed_response['email'])
    return user if user.persisted?

    user.assign_attributes(name: response.parsed_response['name'])
    user.remote_avatar_url = response.parsed_response['picture']
    user.save(validate: false)
    user
  end

  private

  def authorization_header
    { Authorization: "#{@token_type} #{@access_token}" }
  end
end
