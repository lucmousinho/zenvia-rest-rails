module Zenvia
  class Configuration
    attr_accessor :account, :code, :callback_option, :from

    def initialize
      @account  = ''
      @code     = ''
      @callback_option = 'NONE'
      @from     = ''
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

end
