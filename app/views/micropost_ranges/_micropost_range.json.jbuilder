json.extract! micropost_range, :id, :range_id, :range_content, :created_at, :updated_at
json.url micropost_range_url(micropost_range, format: :json)
