class Heroku::Command::Cleanup < Heroku::Command::Base

  def mine
    heroku.list.each do |app, owner|
      if owner == 'david@heroku.com'
        if confirm("Delete #{app} (Y/N)?")
          heroku.destroy(app)
        end
      end
    end
  end

  def shared
    heroku.list.each do |app, owner|
      next if owner == 'ddollar@gmail.com'
      next if owner =~ /heroku\.com$/
      puts "Removing david@heroku.com from app: #{app}"
      heroku.remove_collaborator(app, 'david@heroku.com')
    end
  end

end
