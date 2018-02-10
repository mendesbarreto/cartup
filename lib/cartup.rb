require "CartBinaryUploader/version"
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
    config = getConfig

    projectId = config.project.google.project_id
    credentialsFile = config.project.google.credentials_file
    bucketName = config.project.google.bucket
    frameworkName = config.project.framework.name
    frameworkVersion = config.project.framework.version

    gitHelper = GitHelper.new

    googleCloudStorage = GoogleCloudStorage.new(projectId,
                                                credentialsFile,
                                                bucketName,
                                                frameworkName,
                                                frameworkVersion)
    googleCloudStorage.uploadFrameWork
    gitHelper.tagTo frameworkVersion
    gitHelper.push
  end

  def self.init
    CartBinaryUploader.copyTemplateYaml
  end

  def self.copyTemplateYaml
    fromSourceFile = "./lib/template.yaml"
    toDestinationFile = "./cart_uploader.yaml"
    CartBinaryUploader.copy_with_path fromSourceFile, toDestinationFile
  end

  def self.copy_with_path(src, dst)
    FileUtils.mkdir_p(File.dirname(dst))
    FileUtils.cp(src, dst)
  end

  def self.getConfig
    begin
      CartLogger.logInfo "Creating project config"
      path = FileUtils.pwd + '/cart_uploader.yaml'
      yamlFile = YAML.load_file(path)
      object = JSON.parse(yamlFile.to_json, object_class: OpenStruct)
      CartLogger.logInfo "project config Created"
      object
    rescue SystemCallError
      CartLogger.logError "Problem to find or pase yaml file"
      exit
    end

  end

end
