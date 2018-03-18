require 'aws-sdk-s3'
require 'fileutils'
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
      setupS3Global
      super(bucket_name, framework_name, framework_version)
    end

    def setupS3Global
      Aws.config.update({region: @region_name, credentials: Aws::Credentials.new(@bucket_access_key, @bucket_secret_key)})
    end

    def create_storage
      @storage = Aws::S3::Resource.new(region: region_name)
    end

    def create_bucket
      @bucket = @storage.bucket(@bucket_name).object(@bucket_secret_key)
    end

    def create_file(framework_name_source, framework_name_destination)
      @bucket_object = Aws::S3::Object.new(key: file_path,
                                            bucket_name: @bucket_name,
                                            client: s3_client)
      @bucket_object.presigned_url(:get, expires_in: 3.154e+8)
    end


    def file_on_storage_cloud(file)
      bucket_file = bucket.file file
      !bucket_file.nil?
    end

    def download_config_json_file(from_file)
      json_file = @bucket.file from_file
      json_file.download from_file
      json_file
    end

    def upload_json(json_path)
      CartLogger.log_info 'Starting upload file to google cloud'
      @bucket.create_file(json_path, json_path)
      CartLogger.log_info 'Uploaded complete'
    end
  end
end
