require ENV['TM_SUPPORT_PATH'] + '/lib/tm/process'
require ENV['TM_SUPPORT_PATH'] + '/lib/escape'
require ENV['TM_SUPPORT_PATH'] + '/lib/exit_codes'

require File.dirname(__FILE__) + '/status_listing'

module Subversion
  class << self

    def svn
      ENV['TM_SVN'] || 'svn'
    end

    def run(*cmd, &error_handler)
      out, err = TextMate::Process.run(svn, cmd, :buffer => false)

      if $? != 0
        if error_handler.nil?
          TextMate.exit_show_tool_tip err
        else
          error_handler.call(err)
        end
      else
        return out
      end
    end

    def status(*dirs) 
      StatusListing.new(Subversion.run("status", "--xml", *dirs))
    end

    def commit(*args)
      Subversion.run("commit", *args)
    end

  end
end