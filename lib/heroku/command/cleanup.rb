class Heroku::Command::Cleanup < Heroku::Command::Base

  def mine
    heroku.list.each do |app, owner|
      if owner == user && confirm("Delete #{app} (Y/N)?")
        heroku.destroy(app)
      end
    end
  end

  def shared
    heroku.list.each do |app, owner|
      next if owner == user
      next if owner =~ /@heroku\.com$/
      puts "Removing #{user} from app: #{app}"
      heroku.remove_collaborator(app, user)
    end
  end

  private
  def user
    Heroku::Command::Auth.new("").user
  rescue NoMethodError
    Heroku::Auth.user
  end

end
