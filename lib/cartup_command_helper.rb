require 'cartup'

module CartBinaryUploader
  class CartupCommandHelper
    COMMAND_RUN = 'run'.freeze
    COMMAND_INIT = 'init'.freeze
    COMMAND_HELP = 'help'.freeze

    attr_reader :help_description

    def initialize
      @help_description = <<-EOF
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
        print_helper
      else
        print_helper
      end
    end

    def print_helper
      puts @help_description
    end

  end
end
