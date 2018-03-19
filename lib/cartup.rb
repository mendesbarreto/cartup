require 'CartBinaryUploader/version'
require 'fileutils'
require 'yaml'
require 'json'
require 'ostruct'
require 'storage/google_cloud_storage'
require 'storage/storage_type'
require 'git_tools/git_helper'
require 'cartup_command_helper'
require 'cart_logger'
require 'storage/s3_cloud_storage'

module CartBinaryUploader
  def self.run
    config = get_config

    framework_version = config.project.framework.version

    git_helper = GitHelper.new

    cloud_storage = setup config
    cloud_storage.upload_framework
    git_helper.tag_to framework_version
    git_helper.push
  end

  def self.setup config
    setup_s3_cloud config
    # if !config.project.google?
    #   CartLogger.log_info 'Starting with google cloud'
    #   setup_google_cloud config
    # else
    #   CartLogger.log_info 'Starting with s3 cloud'
    #   setup_s3_cloud config
    # end
  end

  def self.setup_google_cloud(config)
    GoogleCloudStorage.new(config.project.google.project_id,
                           config.project.google.credentials_file,
                           config.project.google.bucket,
                           config.project.framework.name,
                           config.project.framework.version)
  end

  def self.setup_s3_cloud(config)
    S3CloudStorage.new(config.project.s3.bucket_name,
                       config.project.s3.bucket_access_key,
                       config.project.s3.bucket_secret_key,
                       config.project.s3.region,
                       config.project.framework.name,
                       config.project.framework.version)
  end

  def self.init
    CartBinaryUploader.copy_template_yaml
  end

  def self.copy_template_yaml
    from_source_file = './lib/template.yaml'
    to_destination_file = './cart_uploader.yaml'
    CartBinaryUploader.copy_with_path from_source_file, to_destination_file
  end

  def self.copy_with_path(src, dst)
    FileUtils.mkdir_p(File.dirname(dst))
    FileUtils.cp(src, dst)
  end

  def self.get_config
    begin
      CartLogger.log_info 'Creating project config'
      path = FileUtils.pwd + '/cart_uploader.yaml'
      yaml_file = YAML.load_file(path)
      object = JSON.parse(yaml_file.to_json, object_class: OpenStruct)
      CartLogger.log_info 'project config Created'
      object
    rescue SystemCallError
      CartLogger.log_error 'Problem to find or pase yaml file'
      exit
    end

  end

end
