require 'cart_logger'

class GitHelper

  def tagTo version
    CartLogger.logInfo "Tagging version to:  " + version
    begin
      cmd = "git tag -f " + version
      exec( cmd )
      CartLogger.logInfo "Version tagged"
    rescue
      CartLogger.logError "Problem to generate tag on git"
    end
  end

  def push
    CartLogger.logInfo "Pushing tag to Git "
    begin
      cmd = "git push --tags"
      exec( cmd )
      CartLogger.logInfo "Tag pushed"
    rescue
      CartLogger.logError "Problem to push tag on git"
    end

  end

end