module DowncaseRedirector
  class Configuration
    attr_accessor :exclude_list

    def initialize
      @exclude_list = []
    end
  end
end