require 'logger'
require 'colorize'
require 'colorized_string'

module CartBinaryUploader
  class CartLogger
    class << self
      def log
        if @logger.nil?
          @logger = Logger.new STDOUT
          @logger.level = Logger::DEBUG
          @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
        end
        @logger
      end

      def log_info string
        CartLogger.log.info string
      end

      def log_error string
        CartLogger.log.error string.to_s.colorize(:color => :white, :background => :red)
      end

    end
  end
end
