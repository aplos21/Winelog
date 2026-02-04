json.extract! wine, :id, :name, :description, :rating, :region_id, :created_at, :updated_at
json.url wine_url(wine, format: :json)
