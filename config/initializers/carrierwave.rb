CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'carrierwave'
  if Rails.env.test? or Rails.env.cucumber?
    # File storage if in test environment
    config.storage = :file
  else
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],       # required
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],       # required
      :region                 => 'us-west-1'  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = 'mycelial-images'                     # required
    #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
    config.fog_public     = true                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end
#testing this out.