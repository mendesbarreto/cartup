
class GitHelper

  def tagTo version
    puts "Tagging version to:  " + version
    begin
      cmd = "git tag -f " + version
      exec( cmd )
      puts "Version tagged"
    rescue
      puts "Problem to generate tag on git"
    end
  end

  def push
    puts "Pushing tag to Git "
    begin
      cmd = "git push --tags"
      exec( cmd )
      puts "Tag pushed"
    rescue
      puts "Problem to push tag on git"
    end

  end

end