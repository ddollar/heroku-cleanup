require "yaml"

# cleanup heroku apps
#
class Heroku::Command::Cleanup < Heroku::Command::Base

  # cleanup
  #
  # clean up apps
  #
  def index
    kept = settings["keep"] || []
    apps = api.get_apps.body.reject { |app| kept.include?(app["name"]) }

    apps.each_with_index do |app, idx|
      owner = app["owner_email"] == current_user
      verb  = owner ? "Delete" : "Remove yourself from"
      print "[#{idx+1}/#{apps.length}] #{verb} #{app["name"]}? [y/N/k] "
      case $stdin.gets.chomp.strip.downcase
        when "y" then
          owner ? api.delete_app(app["name"]) : api.delete_collaborator(app["name"], current_user)
        when "k" then
          keep app["name"]
      end
    end

    names = api.get_apps.body.map { |app| app["name"] }
    (kept - names).each do |name|
      unkeep name
    end
  end

private

  def current_user
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

  def unkeep(app)
    set = settings.dup
    set["keep"] ||= []
    set["keep"].delete app
    set["keep"].uniq!
    set["keep"].sort!
    write_settings set
  end

end
