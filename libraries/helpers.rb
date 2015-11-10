module RsyslogCookbook
  # helpers for the various service providers on Ubuntu systems
  module Helpers
    # determine if chef solo search is available
    def chef_solo_search_installed?
      klass = ::Search.const_get('Helper')
      return klass.is_a?(Class)
    rescue NameError
      return false
    end
  end
end
