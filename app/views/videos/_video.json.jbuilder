json.extract! video, :id, :nume, :descriere, :sursa, :link, :created_at, :updated_at
json.url video_url(video, format: :json)
