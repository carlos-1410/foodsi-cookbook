module AuthHelpers
  def auth_headers(user)
    { "Authorization" => user.token }
  end
end
