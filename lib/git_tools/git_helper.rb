require 'cart_logger'

class GitHelper

  def tag_to version
    CartLogger.log_info "Tagging version to:  #{version}"
    begin
      cmd = "git tag -f #{version}"
      exec(cmd)
      CartLogger.log_info 'Version tagged'
    rescue
      CartLogger.log_error 'Problem to generate tag on git'
    end
  end

  def push
    CartLogger.log_info 'Pushing tag to Git '
    begin
      cmd = 'git push --tags'
      exec( cmd )
      CartLogger.log_info 'Tag pushed'
    rescue
      CartLogger.log_error 'Problem to push tag on git'
    end

  end

end