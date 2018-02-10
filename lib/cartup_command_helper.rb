require "cartup"

module CartBinaryUploader
  class CartupCommandHelper
    COMMAND_RUN = "run"
    COMMAND_INIT = "init"
    COMMAND_HELP = "help"

    attr_reader :helpDescription

    def initialize
      @helpDescription = <<-EOF
        These are common Cartup commands used in some situations: 
        - init      Create an empty cart_uploader.yaml 
        - run       uploading the Carthage prebuilts to a cloud storage
        - help      show help instructions and list available subcommands
      EOF
    end


    def handle(command)
      case command
        when COMMAND_RUN
          CartBinaryUploader.run
        when COMMAND_INIT
          CartBinaryUploader.init
        when COMMAND_HELP
          printHelper
        else
          printHelper
      end
    end

    def printHelper
      puts @helpDescription
    end

  end
end
