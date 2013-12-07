json.array!(@subscriptions) do |subscription|
  json.extract! subscription, :location_id, :user_id
  json.url subscription_url(subscription, format: :json)
end
