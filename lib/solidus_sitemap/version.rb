module SolidusSitemap
  module_function

  # Returns the version of the currently loaded SolidusSitemap as a
  # <tt>Gem::Version</tt>.
  def version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 4
    MINOR = 0
    TINY  = 0
    PRE   = 'RELEASE'

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end
