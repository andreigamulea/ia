Aws.config.update({
  region: 'eu-central-2', # Regiunea selectată pentru Wasabi
  credentials: Aws::Credentials.new(
    Rails.application.credentials.wasabi[:access_key_id], 
    Rails.application.credentials.wasabi[:secret_access_key]
  )
})

S3_CLIENT = Aws::S3::Client.new(
  endpoint: 'https://s3.eu-central-2.wasabisys.com', # Endpoint-ul corect pentru Wasabi
  region: 'eu-central-2'
)
