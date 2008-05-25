require ENV['TM_SUPPORT_PATH'] + '/lib/tm/process'
require ENV['TM_SUPPORT_PATH'] + '/lib/ui'
require ENV['TM_SUPPORT_PATH'] + '/lib/exit_codes'

TextMate::UI.alert(:critical, "An SVN Bundle error occurred", "tmsvn.rb received no arguments", "OK") if ARGV.empty?

script = ARGV.shift
out,err = TextMate::Process.run(ENV['TM_RUBY'], "#{File.dirname(__FILE__)}/#{script}.rb", ARGV)

if $? != 0
  TextMate::UI.alert(:critical, "An error occurred within the Subverion bundle", err, "OK") if not err.empty?
  TextMate.exit_discard
end

STDOUT << out