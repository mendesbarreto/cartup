require 'google/cloud/storage'
require 'fileutils'
require 'yaml'
require 'json'
require 'cart_logger'

module CartBinaryUploader
  class GoogleCloudStorage

    FRAMEWORK_EXTENSION_NAME = ".framework"
    JSON_EXTENSION_NAME = ".json"
    JSON_EXTENSION_ZIP = ".zip"

    attr_accessor :projectId
    attr_accessor :credentialsFilePath
    attr_accessor :bucketName
    attr_accessor :frameworkName
    attr_accessor :frameworkVersion

    attr_accessor :storage
    attr_accessor :bucket

    def initialize( projectId, credentialsFile, bucketName, frameworkName, frameworkVersion )
      @projectId = projectId
      @credentialsFilePath = credentialsFile
      @bucketName = bucketName
      @frameworkName = frameworkName
      @frameworkVersion = frameworkVersion
      createStorage
      createBucket
    end

    def createStorage
      CartLogger.logInfo "Creating google storage with id: " + @projectId + "credenciasPath: " + @credentialsFilePath
      @storage = Google::Cloud::Storage.new(
          project_id: @projectId,
          credentials: @credentialsFilePath
      )
    end

    def createBucket
      CartLogger.logInfo "Creating bucket name: " + @bucketName
      @bucket = @storage.bucket @bucketName
    end

    def uploadFrameWork
      CartLogger.logInfo "Prepering to upload file to google cloud"
      frameworkNameSource = @frameworkName + FRAMEWORK_EXTENSION_NAME + JSON_EXTENSION_ZIP
      frameworkNameDestination = @frameworkName + FRAMEWORK_EXTENSION_NAME + "." + @frameworkVersion + JSON_EXTENSION_ZIP
      jsonPath = @frameworkName + JSON_EXTENSION_NAME

      CartLogger.logInfo "Framework Source: " + frameworkNameSource
      CartLogger.logInfo "Framework Destination: " + frameworkNameDestination
      CartLogger.logInfo "JSON Path: " + jsonPath

      unless !hasFileOnGoogleCloud frameworkNameDestination
        throw :the_version_file_already_exists, "The current version: " + @frameworkVersion + " already exists on google cloud"
      else
        CartLogger.logInfo "File version "+ @frameworkVersion +" not exists yet, starting generate file on google cloud"
        jsonFile = downloadZConfigJsonFile(jsonPath)

        if jsonFile.nil?
          throw :could_not_download_json_file, "JSON With name: " + jsonPath
        end

        frameworkFile = bucket.create_file(frameworkNameSource, frameworkNameDestination)
        sharedUrl = frameworkFile.signed_url(method: 'GET', expires: 3.154e+8)

        jsonObject = loadJSONObject jsonPath
        jsonObject[@frameworkVersion] = sharedUrl

        saveJSONObject(jsonPath, jsonObject)

        uploadJson jsonPath
      end
    end

    def hasFileOnGoogleCloud file
      CartLogger.logInfo "Verifying if the version file "+ file +" already exists"
      bucketFile = bucket.file file
      !bucketFile.nil?
    end

    def downloadZConfigJsonFile fromFile
      #jsonPath = 'CarrefourAPI.json'
      jsonFile = @bucket.file fromFile
      jsonFile.download fromFile
      jsonFile
    end

    def loadJSONObject jsonPath
      CartLogger.logInfo "Loading JSON file"
      json = File.read(jsonPath)
      object = JSON.parse(json)
      CartLogger.logInfo object
      CartLogger.logInfo "JSON Loaded"
      object
    end

    def saveJSONObject(jsonPath, jsonObject)
      binaryJson = JSON.pretty_generate(jsonObject)
      CartLogger.logInfo "Saving JSON Object in: " + jsonPath + "JSON: " + binaryJson
      File.write(jsonPath, binaryJson)
      CartLogger.logInfo "JSON Saved"
    end


    def uploadJson jsonPath
      CartLogger.logInfo "Starting upload file to google cloud"
      @bucket.create_file(jsonPath, jsonPath)
      CartLogger.logInfo "Uploaded complete"
    end

  end
end

