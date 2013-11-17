json.array!(@offerings) do |offering|
  json.extract! offering, 
  json.url offering_url(offering, format: :json)
end
