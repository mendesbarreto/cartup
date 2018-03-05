require 'CartBinaryUploader/version'
require 'fileutils'
require 'yaml'
require 'json'
require 'ostruct'
require 'google_cloud_storage'
require 'git_helper'
require 'cartup_command_helper'
require 'cart_logger'

module CartBinaryUploader
  def self.run
    config = get_config

    project_id = config.project.google.project_id
    credentials_file = config.project.google.credentials_file
    bucket_name = config.project.google.bucket
    framework_name = config.project.framework.name
    framework_version = config.project.framework.version

    git_helper = GitHelper.new

    google_cloud_storage = GoogleCloudStorage.new(project_id,
                                                credentials_file,
                                                bucket_name,
                                                framework_name,
                                                framework_version)
    google_cloud_storage.upload_framework
    git_helper.tag_to framework_version
    git_helper.push
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
