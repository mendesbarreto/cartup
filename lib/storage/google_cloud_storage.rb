require 'google/cloud/storage'
require 'fileutils'
require 'yaml'
require 'json'
require 'cart_logger'
require_relative 'storage_type'

module CartBinaryUploader
  class GoogleCloudStorage < Storage
    attr_accessor :credentials_file_path
    attr_accessor :project_id

    def initialize(project_id,
                   credentials_file,
                   bucket_name,
                   framework_name,
                   framework_version)
      @credentials_file_path = credentials_file
      @project_id = project_id
      super(bucket_name, framework_name, framework_version)
    end

    def create_storage
      @storage = Google::Cloud::Storage.new(project_id: @project_id,
                                            credentials: @credentials_file_path)
    end

    def create_bucket
      @bucket = @storage.bucket @bucket_name
    end

    def create_file(file_path)
      @bucket_object = @bucket.create_file(file_path, file_path)
      @bucket_object.signed_url(method: 'GET', expires: 3.154e+8)
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

