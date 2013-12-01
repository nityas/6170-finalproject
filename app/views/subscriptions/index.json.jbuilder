json.array!(@subscriptions) do |subscription|
  json.extract! subscription, :building_id, :user_id
  json.url subscription_url(subscription, format: :json)
end
