require "CartBinaryUploader/version"
require 'fileutils'
require 'yaml'
require 'json'
require 'ostruct'
require 'google_cloud_storage'
require 'git_helper'

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

  def self.getConfig
    begin
      puts "Creating project config"
      path = FileUtils.pwd + '/cart_uploader.yaml'
      yamlFile = YAML.load_file(path)
      object = JSON.parse(yamlFile.to_json, object_class: OpenStruct)
      puts "project config Created"
      object
    rescue SystemCallError
      puts "Problem to find or pase yaml file"
      exit
    end

  end

end
