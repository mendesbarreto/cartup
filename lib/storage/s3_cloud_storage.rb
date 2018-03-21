require 'aws-sdk-s3'
require 'fileutils'
require 'json'
require 'yaml'
require 'json'
require 'cart_logger'
require_relative 'storage_type'

module CartBinaryUploader
  class S3CloudStorage < Storage

    attr_accessor :region_name
    attr_accessor :bucket_secret_key
    attr_accessor :bucket_access_key

    def initialize(bucket_name,
                   bucket_secrete_key,
                   bucket_acess_key,
                   region_name,
                   framework_name,
                   framework_version)
      @region_name = region_name
      @bucket_secret_key = bucket_secrete_key
      @bucket_access_key = bucket_acess_key
      setup_s3_global
      super(bucket_name, framework_name, framework_version)
    end

    def setup_s3_global
      Aws.config = {
          :access_key_id => @bucket_access_key,
          :secret_access_key => @bucket_secret_key,
          :region => @region_name,
      }
    end

    def create_storage
      @storage = Aws::S3::Resource.new(credentials: Aws::Credentials.new(@bucket_secret_key, @bucket_access_key),
                                       region: @region_name)
    end

    def create_bucket
      @bucket = @storage.bucket(@bucket_name)
    end

    def create_file(file_path)
      puts "Creating #{file_path} on s3"
      @bucket_object = @bucket.object(file_path)
      @bucket_object.upload_file("./#{file_path}", acl:'public-read')
      puts "Object #{file_path} created with url #{@bucket_object.public_url}"
      @bucket_object.public_url
    end


    def file_on_storage_cloud(file)
      @bucket.objects.each do |object|
        if object.key == file
          return true
        end
      end
      false
    end

    def download_config_json_file(from_file)
      @bucket.object(from_file)
    end

    def upload_json(json_path)
      CartLogger.log_info 'Starting upload json file to s3 cloud'
      create_file(json_path)
      CartLogger.log_info 'Uploaded complete'
    end
  end
end
