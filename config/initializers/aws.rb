require 'aws-sdk-s3'

# obviously this file wont work in github actions because it needs the env variables to be set

Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new('AKIAXBOXQNGXMMYSZ42M',
    '0Sgfupj9iFCPe5ZxBESgmB2Wpb0rUjCKbNB0QISv'),
})

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])