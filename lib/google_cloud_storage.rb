require 'google/cloud/storage'
require 'fileutils'
require 'yaml'
require 'json'
require 'cart_logger'

module CartBinaryUploader
  class GoogleCloudStorage

    FRAMEWORK_EXTENSION_NAME = '.framework'.freeze
    JSON_EXTENSION_NAME = '.json'.freeze
    JSON_EXTENSION_ZIP = '.zip'.freeze

    attr_accessor :project_id
    attr_accessor :credentials_file_path
    attr_accessor :bucket_name
    attr_accessor :framework_name
    attr_accessor :framework_version

    attr_accessor :storage
    attr_accessor :bucket

    def initialize(project_id,
                   credentials_file,
                   bucket_name,
                   framework_name,
                   framework_version )
      @project_id = project_id
      @credentials_file_path = credentials_file
      @bucket_name = bucket_name
      @framework_name = framework_name
      @framework_version = framework_version
      create_storage
      create_bucket
    end

    def create_storage
      CartLogger.log_info "Creating storage with id: #{@project_id} path: #{@credentials_file_path}"
      @storage = Google::Cloud::Storage.new(project_id: @project_id,
                                            credentials: @credentials_file_path)
    end

    def create_bucket
      CartLogger.log_info "Creating bucket name: #{@bucket_name}"
      @bucket = @storage.bucket @bucket_name
    end

    def upload_framework
      CartLogger.log_info "Prepering to upload file to google cloud"
      framework_name_source = @framework_name + FRAMEWORK_EXTENSION_NAME + JSON_EXTENSION_ZIP
      framework_name_destination = @framework_name + FRAMEWORK_EXTENSION_NAME + "." + @framework_version + JSON_EXTENSION_ZIP
      json_path = @framework_name + JSON_EXTENSION_NAME

      CartLogger.log_info "Framework Source: #{framework_name_source}"
      CartLogger.log_info "Framework Destination: #{framework_name_destination}"
      CartLogger.log_info "JSON Path: #{json_path}"

      unless !has_file_on_google_cloud framework_name_destination
        throw :the_version_file_already_exists, "The current version: #{@framework_version} already exists on google cloud"
      else
        CartLogger.log_info "File version #{@framework_version} not exists yet, starting generate file on google cloud"
        json_file = download_config_json_file(json_path)

        if json_file.nil?
          throw :could_not_download_json_file, "JSON With name: #{json_path}"
        end

        framework_file = bucket.create_file(framework_name_source, framework_name_destination)
        shared_url = framework_file.signed_url(method: 'GET', expires: 3.154e+8)

        json_object = load_json_object json_path
        json_object[@framework_version] = shared_url

        save_json_object(json_path, json_object)

        upload_json json_path
      end
    end

    def has_file_on_google_cloud file
      CartLogger.log_info "Verifying if the version file #{file} already exists"
      bucket_file = bucket.file file
      !bucket_file.nil?
    end

    def download_config_json_file(from_file)
      json_file = @bucket.file from_file
      json_file.download from_file
      json_file
    end

    def load_json_object(json_path)
      CartLogger.log_info 'Loading JSON file'
      json = File.read(json_path)
      object = JSON.parse(json)
      CartLogger.log_info object
      CartLogger.log_info 'JSON Loaded'
      object
    end

    def save_json_object(json_path, json_object)
      binary_json = JSON.pretty_generate(json_object)
      CartLogger.log_info "Saving JSON Object in: #{json_path} JSON: #{binary_json}"
      File.write(json_path, binary_json)
      CartLogger.log_info 'JSON Saved'
    end


    def upload_json jsonPath
      CartLogger.log_info 'Starting upload file to google cloud'
      @bucket.create_file(jsonPath, jsonPath)
      CartLogger.log_info 'Uploaded complete'
    end

  end
end

