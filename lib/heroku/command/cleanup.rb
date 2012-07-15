require "yaml"

# cleanup heroku apps
#
class Heroku::Command::Cleanup < Heroku::Command::Base

  # cleanup:mine
  #
  # prompt to delete each app you own
  #
  def mine
    kept = (settings["keep"] || [])
    candidates = heroku.list.map do |app, owner|
      next unless owner == user
      next if kept.include?(app)
      [ app, owner ]
    end.compact
    candidates.each_with_index do |(app, owner), idx|
      print "[#{idx+1}/#{candidates.length}] Delete #{app}? [y/n/k] "
      case $stdin.gets.chomp.strip.downcase
        when "y" then heroku.destroy(app)
        when "k" then keep(app)
      end
    end
  end

  # cleanup:shared
  #
  # prompt to remove collaborator access to any non-heroku.com-owned app
  #
  def shared
    kept = (settings["keep"] || [])
    candidates = heroku.list.map do |app, owner|
      next if owner == user
      next if kept.include?(app)
      [ app, owner ]
    end.compact
    candidates.each_with_index do |(app, owner), idx|
      print "[#{idx+1}/#{candidates.length}] Remove #{user} from #{app}? [y/n/k] "
      case $stdin.gets.chomp.strip.downcase
        when "y" then heroku.remove_collaborator(app, user)
        when "k" then keep(app)
      end
    end
  end

private

  def user
    Heroku::Command::Auth.new("").user
  rescue NoMethodError
    Heroku::Auth.user
  end

  def settings_file
    File.expand_path("~/.heroku/cleanup.yml")
  end

  def settings
    YAML.load_file(settings_file) rescue {}
  end

  def write_settings(settings)
    File.open(settings_file, "w") do |file|
      file.puts YAML.dump(settings)
    end
  end

  def keep(app)
    set = settings.dup
    set["keep"] ||= []
    set["keep"] << app
    set["keep"].uniq!
    set["keep"].sort!
    write_settings set
  end

end
