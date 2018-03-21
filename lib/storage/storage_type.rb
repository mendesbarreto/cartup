require 'fileutils'
require 'yaml'
require 'json'
require 'cart_logger'

module CartBinaryUploader
  class Storage
    FRAMEWORK_EXTENSION_NAME = '.framework'.freeze
    JSON_EXTENSION_NAME = '.json'.freeze
    JSON_EXTENSION_ZIP = '.zip'.freeze

    attr_accessor :bucket_name
    attr_accessor :framework_name
    attr_accessor :framework_version
    attr_accessor :bucket
    attr_accessor :json_file
    attr_accessor :bucket_object

    def initialize(bucket_name,
                   framework_name,
                   framework_version)
      @bucket_name = bucket_name
      @framework_name = framework_name
      @framework_version = framework_version

      CartLogger.log_info "Creating storage"
      create_storage
      CartLogger.log_info "Creating bucket name: #{@bucket_name}"
      create_bucket
    end

    def create_storage
      throw :not_implemented, "The current method not implemented"
    end

    def create_bucket
      throw :not_implemented, "The current method not implemented"
    end

    def upload_framework
      CartLogger.log_info "Prepering to upload file to cloud"
      framework_name_source = @framework_name + FRAMEWORK_EXTENSION_NAME + JSON_EXTENSION_ZIP
      framework_name_destination = @framework_name + FRAMEWORK_EXTENSION_NAME + "." + @framework_version + JSON_EXTENSION_ZIP
      json_path = @framework_name + JSON_EXTENSION_NAME

      CartLogger.log_info "Framework Source: #{framework_name_source}"
      CartLogger.log_info "Framework Destination: #{framework_name_destination}"
      CartLogger.log_info "JSON Path: #{json_path}"

      CartLogger.log_info "Verifying if the version file #{framework_name_destination} already exists"
      unless file_on_storage_cloud framework_name_destination
        CartLogger.log_info "File version #{@framework_version} not exists yet, starting generate file on cloud"

        if file_on_storage_cloud(json_path)
          @json_file = download_config_json_file(json_path)
          if @json_file.nil?
            throw :could_not_download_json_file, "JSON With name: #{json_path}"
          end
        else
          CartLogger.log_warn "Creating empty json because it not exsits yet on cloud"
          create_empty_json_file(json_path)
        end

        copy_local_file(framework_name_source, framework_name_destination)

        shared_url = create_file(framework_name_destination)

        json_object = load_json_object json_path
        json_object[@framework_version] = shared_url

        save_json_object(json_path, json_object)

        CartLogger.log_info 'Starting upload file to storage cloud'
        upload_json json_path
        CartLogger.log_info 'Uploaded complete'
      else
        throw :the_version_file_already_exists, "The current version: #{@framework_version} already exists on cloud"
      end
    end

    def create_file(file_path)
      throw :not_implemented, "The current method not implemented"
    end

    def create_public_url(file_path)
      throw :not_implemented, "The current method not implemented"
    end

    def create_local_file(file_name)
      throw :not_implemented, "The current method not implemented"
    end

    def file_on_storage_cloud(file)
      throw :not_implemented, "The current method not implemented"
    end

    def download_config_json_file(from_file)
      throw :not_implemented, "The current method not implemented"
    end

    def upload_json jsonPath
      throw :not_implemented, "The current method not implemented"
    end

    def copy_local_file(framework_name_source, framework_name_destination)
      FileUtils.copy_file(framework_name_source, framework_name_destination)
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

    def create_empty_json_file(file_name)
      json_object = JSON.parse('{}')
      save_json_object(file_name, json_object)
    end
  end
end
