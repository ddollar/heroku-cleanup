require 'heroku/command/cleanup'

Heroku::Command::Help.group('Cleanup') do |group|
  group.command('cleanup:mine',   'Clean up my apps')
  group.command('cleanup:shared', 'Clean up shared apps')
end