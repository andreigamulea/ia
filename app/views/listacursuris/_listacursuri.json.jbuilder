json.extract! listacursuri, :id, :nume, :created_at, :updated_at
json.url listacursuri_url(listacursuri, format: :json)
