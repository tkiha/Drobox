json.array!(@users) do |user|
  json.extract! user, :id, :name, :mail, :password
  json.url user_url(user, format: :json)
end
